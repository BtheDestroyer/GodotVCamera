tool
extends "res://addons/virtualcamera/TransformModifiers/TransformModifier.gd"
# Follows target keeping set distance and offset.
class_name Follow

# Target to follow (settable from editor).
export var target_path : NodePath
# Target to follow (settable runtime).
var target : Spatial

# Offset to apply from target's position in global coordinates.
export var offset : Vector3 = Vector3.ZERO

# Distance that Follow isn't allowed to go any closer to target.
export(float, EXP, 0.0, 2048.0) var min_distance : float = 1.0
# Softer margin starting from min_distance outwards which pushes Follow gently away from target.
export(float, EXP, 0.0, 1024.0) var min_distance_push_margin : float = 1.0
# Strength at which Follow will be pushed away if it were at min_distance away.
export(float, EXP, 0.0, 100.0) var min_distance_push_strength : float = 10.0
# How pushing strength will lessen when approaching end of margin.
export(float, EASE) var min_distance_push_easing : float = 2.0

# Distance that Follow isn't allowed to go any farther away from target.
export(float, EXP, 0.0, 2048.0) var max_distance : float = 2.0
# Softer margin starting from max_distance inwards which pulls Follow gently towards target.
export(float, EXP, 0.0, 1024.0) var max_distance_push_margin : float = 1.0
# Strength at which Follow will be pulled if it were at max_distance away.
export(float, EXP, 0.0, 100.0) var max_distance_push_strength : float = 10.0
# How pushing strength will lessen when approaching end of margin.
export(float, EASE) var max_distance_push_easing : float = 2.0

# Don't affect axes defined by bit mask.
# Bit 0b001: X axis
# Bit 0b010: Y axis
# Bit 0b100: Z axis
export(int, FLAGS, "X", "Y", "Z") var lock_axes : int = 0


func _ready() -> void:
	if target_path:
		target = get_node(target_path)

func _physics_process(delta : float):
	# _ready() doesn't get called in-editor so set target every frame so update target for better experience.
	# In-game however, other scripts may set target directly, so we shouldn't override those.
	if Engine.editor_hint and target_path:
		target = get_node(target_path)
	
	if is_instance_valid(target):
		# Calculate relative position to target. If some of the axes are locked, treat them as being already at target's level.
		var target_position : Vector3 = target.global_transform.origin + offset
		var relative_to_target : Vector3  = global_transform.origin - target_position
		if lock_axes & 0b001:
			relative_to_target.x = 0
		if lock_axes & 0b010:
			relative_to_target.y = 0
		if lock_axes & 0b100:
			relative_to_target.z = 0
		
		var distance = relative_to_target.length()
		distance = max(min_distance, distance)
		distance = min(max_distance, distance)
		
		var push_strength = max(0, inverse_lerp(min_distance + min_distance_push_margin, min_distance, distance))
		push_strength = ease(push_strength, min_distance_push_easing)
		distance += push_strength * delta * min_distance_push_strength
		
		push_strength = max(0, inverse_lerp(max_distance - max_distance_push_margin, max_distance, distance))
		push_strength = ease(push_strength, max_distance_push_easing)
		distance -= push_strength * delta * max_distance_push_strength
		
		# Calculate new position but don't affect any locked axes.
		var new_position = target_position + relative_to_target.normalized() * distance
		if lock_axes & 0b001:
			new_position.x = global_transform.origin.x
		if lock_axes & 0b010:
			new_position.y = global_transform.origin.y
		if lock_axes & 0b100:
			new_position.z = global_transform.origin.z
		global_transform.origin = new_position

func _process(delta: float) -> void:
	if Engine.editor_hint:
		_rebuild_gizmo()

func _exit_tree() -> void:
	if is_instance_valid(_gizmo):
		_gizmo.queue_free()

# Gizmos
var _gizmo : ImmediateGeometry
const _gizmo_color = Color(0.2, 0.4, 1)

func _rebuild_gizmo():
	_instantiate_gizmo()
	_build_gizmo()

func _instantiate_gizmo():
	if not is_instance_valid(_gizmo):
		_gizmo = ImmediateGeometry.new()
		get_tree().root.add_child(_gizmo)

func _build_gizmo():
	_gizmo.global_transform.origin = global_transform.origin
	_gizmo.clear()
	var mat = SpatialMaterial.new()
	mat.flags_unshaded = true
	mat.vertex_color_use_as_albedo = true
	_gizmo.material_override = mat
	if (not lock_axes & 0b100) and (not lock_axes & 0b010):
		_add_distance_circles_to_gizmo(Vector3.RIGHT)
	if (not lock_axes & 0b100) and (not lock_axes & 0b001):
		_add_distance_circles_to_gizmo(Vector3.UP)
	if (not lock_axes & 0b010) and (not lock_axes & 0b001):
		_add_distance_circles_to_gizmo(Vector3.FORWARD)
	
	if lock_axes & 0b100 and lock_axes & 0b010:
		_add_distance_lines_to_gizmo(Vector3.RIGHT)
		_add_distance_lines_to_gizmo(Vector3.LEFT)
	if lock_axes & 0b100 and lock_axes & 0b001:
		_add_distance_lines_to_gizmo(Vector3.UP)
		_add_distance_lines_to_gizmo(Vector3.DOWN)
	if lock_axes & 0b010 and lock_axes & 0b001:
		_add_distance_lines_to_gizmo(Vector3.FORWARD)
		_add_distance_lines_to_gizmo(Vector3.BACK)

func _add_distance_circles_to_gizmo(normal : Vector3):
	_add_circle_to_gizmo(Vector3.ZERO, min_distance, normal)
	_add_dashed_circle_to_gizmo(Vector3.ZERO, min_distance + min_distance_push_margin, normal)
	_add_circle_to_gizmo(Vector3.ZERO, max_distance, normal)
	_add_dashed_circle_to_gizmo(Vector3.ZERO, max_distance - max_distance_push_margin, normal)

func _add_distance_lines_to_gizmo(direction : Vector3):
	_add_dashed_line_to_gizmo(direction * min_distance, direction * (min_distance + min_distance_push_margin))
	_add_line_to_gizmo(direction * (min_distance + min_distance_push_margin), direction * (max_distance - max_distance_push_margin))
	_add_dashed_line_to_gizmo(direction * max_distance, direction * (max_distance - max_distance_push_margin))

func _add_circle_to_gizmo(offset : Vector3, radius : float, normal : Vector3 = Vector3.UP, segment_length : float = .3):
	if radius <= 0:
		return
	
	var vertices : int = TAU / segment_length * radius
	var vertex_pos = normal.cross(Vector3.FORWARD if normal != Vector3.FORWARD else Vector3.UP) * radius
	var vertex_angle = TAU / vertices
	
	_gizmo.begin(Mesh.PRIMITIVE_LINE_LOOP)
	_gizmo.set_color(_gizmo_color)
	
	for i in vertices:
		_gizmo.add_vertex(Quat(normal, vertex_angle * i) * vertex_pos + offset)
	
	_gizmo.end()

func _add_dashed_circle_to_gizmo(offset : Vector3, radius : float, normal : Vector3 = Vector3.UP, segment_length : float = .3):
	if radius <= 0:
		return
	
	var vertices : int = TAU / segment_length * radius
	vertices += vertices % 2 # Ensure even amount
	var vertex_pos = normal.cross(Vector3.FORWARD if normal != Vector3.FORWARD else Vector3.UP) * radius
	var vertex_angle = TAU / vertices
	
	_gizmo.begin(Mesh.PRIMITIVE_LINES)
	_gizmo.set_color(_gizmo_color)
	
	for i in range(0, vertices, 2):
		_gizmo.add_vertex(Quat(normal, vertex_angle * i) * vertex_pos + offset)
		_gizmo.add_vertex(Quat(normal, vertex_angle * (i + 1)) * vertex_pos + offset)
	
	_gizmo.end()

func _add_line_to_gizmo(from : Vector3, to : Vector3) -> void:
	_gizmo.begin(Mesh.PRIMITIVE_LINES)
	_gizmo.set_color(_gizmo_color)
	
	_gizmo.add_vertex(from)
	_gizmo.add_vertex(to)
	
	_gizmo.end()

func _add_dashed_line_to_gizmo(from : Vector3, to : Vector3, segment_length : float = .1) -> void:
	var direction : Vector3 = to - from
	var direction_length = direction.length()
	if direction_length == 0:
		return
	
	var vertices : int = direction_length / segment_length
	vertices += vertices % 2 # Ensure even amount
	segment_length = direction_length / vertices
	direction = direction.normalized() * segment_length
	
	_gizmo.begin(Mesh.PRIMITIVE_LINES)
	_gizmo.set_color(_gizmo_color)
	
	for i in range(0, vertices, 2):
		_gizmo.add_vertex(from + direction * i)
		_gizmo.add_vertex(from + direction * (i + 1))
	
	_gizmo.end()
