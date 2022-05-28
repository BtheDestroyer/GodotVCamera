tool
extends "res://addons/virtualcamera/TransformModifiers/TransformModifier.gd"

class_name LookAtGroup

export(Array, NodePath) var look_at_targets : Array
export(Array, Vector3) var target_weights : Array
export var look_at_lerp_t : float = 1.0
export var look_at_offset : Vector3 = Vector3.ZERO

var rotation_internal : Quat = Quat.IDENTITY

func has_look_at_target() -> bool:
	return look_at_targets.size() > 0

func _physics_process(delta : float):
	while look_at_targets.size() > target_weights.size():
		target_weights.append(Vector3.ONE)
		property_list_changed_notify()
	if look_at_targets.size() < target_weights.size():
		target_weights.resize(look_at_targets.size())
		property_list_changed_notify()
	if !Engine.editor_hint:
		if has_look_at_target():
			var to_remove = []
			var total_weight = Vector3.ZERO
			for weight in target_weights:
				total_weight += weight
			var target_position = Vector3.ZERO
			for i in look_at_targets.size():
				var target = get_node_or_null(look_at_targets[i])
				if target != null:
					target_position += target_weights[i] / total_weight * target.global_transform.origin
				else:
					to_remove.append(i)
			for i in to_remove:
				look_at_targets.remove(i)
			var target_dist = global_transform.origin - target_position
			if target_dist.length_squared() > 0 and target_dist.normalized().abs() != Vector3.UP:
				rotation = rotation_internal.get_euler()
				look_at(target_position + self.look_at_offset, Vector3.UP)
				rotation_internal = rotation_internal.slerp(Quat(rotation), self.look_at_lerp_t)
				rotation = rotation_internal.get_euler()
