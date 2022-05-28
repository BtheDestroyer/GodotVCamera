tool
extends "res://addons/virtualcamera/TransformModifiers/TransformModifier.gd"

class_name Follow

export var follow_target : NodePath
export(float, 0.0, 1.0) var follow_lerp_t : float = 1.0
export var follow_offset : Vector3 = Vector3.ZERO
export var lock_x : bool = false
export var lock_y : bool = false
export var lock_z : bool = false

func has_follow_target() -> bool:
	return not follow_target.is_empty()
	
func _physics_process(delta : float):
	if not self.follow_target.is_empty():
		var target = get_node_or_null(self.follow_target)
		if target != null:
			if not self.lock_x:
				global_transform.origin.x = lerp(global_transform.origin.x, target.global_transform.origin.x + self.follow_offset.x, self.follow_lerp_t)
			if not self.lock_y:
				global_transform.origin.y = lerp(global_transform.origin.y, target.global_transform.origin.y + self.follow_offset.y, self.follow_lerp_t)
			if not self.lock_z:
				global_transform.origin.z = lerp(global_transform.origin.z, target.global_transform.origin.z + self.follow_offset.z, self.follow_lerp_t)
		else:
			self.follow_target = NodePath()
