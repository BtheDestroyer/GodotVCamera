tool
extends "res://addons/virtualcamera/TransformModifiers/UserInput/UserInput.gd"

class_name Orbiter

export var positive_yaw_mapped_input : String
export var negative_yaw_mapped_input : String
export var positive_pitch_mapped_input : String
export var negative_pitch_mapped_input : String
export var mouse_input : bool = true
export var mouse_sensitivity : float = 0.25
export var rotation_speed : Vector2 = Vector2(1, 1)
export(float, 0.0, 1.0) var lerp_speed : float = 1.0

export var orbit_radii : Vector3 = Vector3(1, 3, 1)
export var orbit_heights : Vector3 = Vector3(2, 1, 0)

export var top_offset : Vector2 = Vector2.ZERO
export var middle_offset : Vector2 = Vector2.ZERO
export var bottom_offset : Vector2 = Vector2.ZERO

onready var input_rotation : Vector2 = Vector2.ZERO
onready var lerped_input_rotation : Vector2 = Vector2.ZERO

func _ready():
	update_translation()

func _input(event : InputEvent):
	if mouse_input and event is InputEventMouseMotion:
		input_rotation.x -= event.relative.x * rotation_speed.x * mouse_sensitivity
		input_rotation.y += event.relative.y * rotation_speed.y * mouse_sensitivity

func _physics_process(delta : float):
	if orbit_radii.x < 0.0:
		orbit_radii.x = 0.0
	if orbit_radii.y < 0.0:
		orbit_radii.y = 0.0
	if orbit_radii.z < 0.0:
		orbit_radii.z = 0.0
	if Engine.editor_hint:
		translation = Vector3.ZERO
	else:
		var yaw_axis = 0.0
		if !negative_yaw_mapped_input.empty():
			yaw_axis -= Input.get_action_strength(negative_yaw_mapped_input)
		if !positive_yaw_mapped_input.empty():
			yaw_axis += Input.get_action_strength(positive_yaw_mapped_input)
		input_rotation.x += yaw_axis * rotation_speed.x * 5
		var pitch_axis = 0.0
		if !negative_pitch_mapped_input.empty():
			pitch_axis -= Input.get_action_strength(negative_pitch_mapped_input)
		if !positive_pitch_mapped_input.empty():
			pitch_axis += Input.get_action_strength(positive_pitch_mapped_input)
		input_rotation.y += pitch_axis * rotation_speed.y * 5
		
		input_rotation.x = wrapf(input_rotation.x, -180, 180)
		input_rotation.y = clamp(input_rotation.y, -90, 90)
		lerped_input_rotation.x = rad2deg(lerp_angle(deg2rad(lerped_input_rotation.x), deg2rad(input_rotation.x), lerp_speed))
		lerped_input_rotation.y = lerp(lerped_input_rotation.y, input_rotation.y, lerp_speed)
		update_translation()

func _process(delta : float):
	if Engine.editor_hint:
		rebuild_geom()

func update_translation():
	var pitch = lerped_input_rotation.y / 90
	var yaw = deg2rad(lerped_input_rotation.x)
	var r = Quat(Vector3.UP, yaw)
	var a = Vector3.UP * orbit_heights.x + r * Vector3.BACK * orbit_radii.x + Vector3(top_offset.x, 0, top_offset.y)
	var b = Vector3.UP * orbit_heights.y + r * Vector3.BACK * orbit_radii.y + Vector3(middle_offset.x, 0, middle_offset.y)
	var c = Vector3.UP * orbit_heights.z + r * Vector3.BACK * orbit_radii.z + Vector3(bottom_offset.x, 0, bottom_offset.y)
	if pitch > 0:
		translation = calculate_curve(c, b, a, a, pitch)
	else:
		translation = calculate_curve(a, b, c, c, abs(pitch))

# Catmull-Rom Spline
func calculate_curve(a : Vector3, b : Vector3, c : Vector3, d : Vector3, t : float):
	var t2 : float = t * t
	var t3 : float = t * t2
	var p0 : float = -t3 + 2.0 * t2 - t
	var p1 : float = 3.0 * t3 - 5.0 * t2 + 2.0
	var p2 : float = -3.0 * t3 + 4.0 * t2 + t
	var p3 : float = t3 - t2
	var result : Vector3 = p0 * a
	result += p1 * b
	result += p2 * c
	result += p3 * d
	return result * 0.5

# Gizmos
var geom : ImmediateGeometry
const color = Color(0.2, 0.4, 1)
func instantiate_geom():
	if Engine.is_editor_hint():
		if geom == null:
			geom = get_node_or_null("geom")
			if geom == null:
				geom = ImmediateGeometry.new()
				geom.set_name("geom")
				add_child(geom)

func add_circle_to_geom(radius : float, offset : Vector3 = Vector3.ZERO, vertices : int = 40, normal : Vector3 = Vector3.UP):
	geom.begin(Mesh.PRIMITIVE_LINE_LOOP)
	geom.set_color(color)
	var vertex_pos = Vector3.BACK * radius
	var vertex_angle = (PI * 2) / vertices
	for i in vertices:
		geom.add_vertex(Quat(normal, vertex_angle * i) * vertex_pos + offset)
	geom.end()

func add_curve_to_geom(a : Vector3, b : Vector3, c : Vector3, vertices : int = 40):
	geom.begin(Mesh.PRIMITIVE_LINE_STRIP)
	geom.set_color(color)
	vertices -= 3
	var half_vertices = vertices / 2
	var step = 1.0 / half_vertices
	geom.add_vertex(a)
	for i in range(1, half_vertices):
		var vertex = calculate_curve(a, a, b, c, step * i)
		geom.add_vertex(vertex)
	geom.add_vertex(b)
	for i in range(1, half_vertices):
		var vertex = calculate_curve(a, b, c, c, step * i)
		geom.add_vertex(vertex)
	geom.add_vertex(c)
	geom.end()

func init_geom():
	if Engine.is_editor_hint() :
		geom.clear()
		var mat = SpatialMaterial.new()
		mat.flags_unshaded = true
		mat.vertex_color_use_as_albedo = true
		geom.material_override = mat
		add_circle_to_geom(orbit_radii.x, Vector3(top_offset.x, orbit_heights.x, top_offset.y))
		add_circle_to_geom(orbit_radii.y, Vector3(middle_offset.x, orbit_heights.y, middle_offset.y))
		add_circle_to_geom(orbit_radii.z, Vector3(bottom_offset.x, orbit_heights.z, bottom_offset.y))
		add_curve_to_geom(
			Vector3.UP * orbit_heights.x + Vector3.BACK * orbit_radii.x + Vector3(top_offset.x, 0, top_offset.y),
			Vector3.UP * orbit_heights.y + Vector3.BACK * orbit_radii.y + Vector3(middle_offset.x, 0, middle_offset.y),
			Vector3.UP * orbit_heights.z + Vector3.BACK * orbit_radii.z + Vector3(bottom_offset.x, 0, bottom_offset.y)
			)
		add_curve_to_geom(
			Vector3.UP * orbit_heights.x + Vector3.RIGHT * orbit_radii.x + Vector3(top_offset.x, 0, top_offset.y),
			Vector3.UP * orbit_heights.y + Vector3.RIGHT * orbit_radii.y + Vector3(middle_offset.x, 0, middle_offset.y),
			Vector3.UP * orbit_heights.z + Vector3.RIGHT * orbit_radii.z + Vector3(bottom_offset.x, 0, bottom_offset.y)
			)
		add_curve_to_geom(
			Vector3.UP * orbit_heights.x + Vector3.FORWARD * orbit_radii.x + Vector3(top_offset.x, 0, top_offset.y),
			Vector3.UP * orbit_heights.y + Vector3.FORWARD * orbit_radii.y + Vector3(middle_offset.x, 0, middle_offset.y),
			Vector3.UP * orbit_heights.z + Vector3.FORWARD * orbit_radii.z + Vector3(bottom_offset.x, 0, bottom_offset.y)
			)
		add_curve_to_geom(
			Vector3.UP * orbit_heights.x + Vector3.LEFT * orbit_radii.x + Vector3(top_offset.x, 0, top_offset.y),
			Vector3.UP * orbit_heights.y + Vector3.LEFT * orbit_radii.y + Vector3(middle_offset.x, 0, middle_offset.y),
			Vector3.UP * orbit_heights.z + Vector3.LEFT * orbit_radii.z + Vector3(bottom_offset.x, 0, bottom_offset.y)
			)

func rebuild_geom():
	instantiate_geom()
	init_geom()

