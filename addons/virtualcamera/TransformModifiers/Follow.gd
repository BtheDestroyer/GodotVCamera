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

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		update_gizmo()
