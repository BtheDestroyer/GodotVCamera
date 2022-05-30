tool
extends Spatial

class_name VCamera, "res://addons/virtualcamera/VCameras/VCamera.svg"

export(int, 0, 1024) var priority : int = 10
export var enabled : bool = true

export var transition_time : float = 1.0
export(float, EASE) var transition_ease : float = -2.0

export(float, 1, 179) var fov : float = 70.0 setget set_fov
func set_fov(value : float) -> void:
	fov = value
	if Engine.editor_hint:
		rebuild_geom()

export(float, EXP, 0.01, 8192) var near : float = 0.05
export(float, EXP, 0.01, 8192) var far : float = 100.0

func _ready():
	if Engine.editor_hint:
		rebuild_geom()
		set_process_priority(-1000)
	add_to_group("vcamera", true)

func _process(delta : float):
	if Engine.editor_hint:
		rebuild_geom()

# Gizmos
var geom : ImmediateGeometry
const color = Color(0.2, 0.6, 0.2)
func instantiate_geom():
	if Engine.is_editor_hint():
		if geom == null:
			geom = get_node_or_null("geom")
			if geom == null:
				geom = ImmediateGeometry.new()
				geom.set_name("geom")
				add_child(geom)

func init_geom():
	if Engine.is_editor_hint() :
		geom.clear()
		var mat = SpatialMaterial.new()
		mat.flags_unshaded = true
		mat.vertex_color_use_as_albedo = true
		var z_len = cos(deg2rad(fov / 2))
		var xy_len = sin(deg2rad(fov / 2))
		geom.material_override = mat
		
		# Cone
		geom.begin(Mesh.PRIMITIVE_LINES)
		geom.set_color(color)
		geom.add_vertex(Vector3(0.0, 0.0, 0.0))
		geom.add_vertex(Vector3(xy_len, xy_len, -z_len))
		geom.add_vertex(Vector3(0.0, 0.0, 0.0))
		geom.add_vertex(Vector3(-xy_len, xy_len, -z_len))
		geom.add_vertex(Vector3(0.0, 0.0, 0.0))
		geom.add_vertex(Vector3(-xy_len, -xy_len, -z_len))
		geom.add_vertex(Vector3(0.0, 0.0, 0.0))
		geom.add_vertex(Vector3(xy_len, -xy_len, -z_len))
		geom.end()
		
		# Square
		geom.begin(Mesh.PRIMITIVE_LINE_STRIP)
		geom.set_color(color)
		geom.add_vertex(Vector3(xy_len, xy_len, -z_len))
		geom.add_vertex(Vector3(-xy_len, xy_len, -z_len))
		geom.add_vertex(Vector3(-xy_len, -xy_len, -z_len))
		geom.add_vertex(Vector3(xy_len, -xy_len, -z_len))
		geom.add_vertex(Vector3(xy_len, xy_len, -z_len))
		geom.end()
		
		# Up pointer
		geom.begin(Mesh.PRIMITIVE_LINE_STRIP)
		geom.set_color(color)
		geom.add_vertex(Vector3(xy_len * -0.25, xy_len, -z_len))
		geom.add_vertex(Vector3(0.0, xy_len * 1.5, -z_len))
		geom.add_vertex(Vector3(xy_len * 0.25, xy_len, -z_len))
		geom.end()

func rebuild_geom():
	instantiate_geom()
	init_geom()
