tool
extends "res://addons/virtualcamera/TransformModifiers/TransformModifier.gd"

class_name LookAt

export var look_at_target : NodePath
export var look_at_lerp_t : float = 1.0
export var look_at_offset : Vector3 = Vector3.ZERO

var rotation_internal : Quat = Quat.IDENTITY

func has_look_at_target() -> bool:
	return not look_at_target.is_empty()

func _physics_process(delta : float):
	if has_look_at_target():
		var target = get_node_or_null(self.look_at_target)
		if target != null:
			var target_dist = global_transform.origin - target.global_transform.origin
			if target_dist.length_squared() > 0 and target_dist.normalized().abs() != Vector3.UP:
				rotation = rotation_internal.get_euler()
				look_at(target.global_transform.origin + self.look_at_offset, Vector3.UP)
				rotation_internal = rotation_internal.slerp(Quat(rotation), self.look_at_lerp_t)
				rotation = rotation_internal.get_euler()
		else:
			self.look_at_target = NodePath()
