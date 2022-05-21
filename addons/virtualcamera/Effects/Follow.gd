tool
extends "res://addons/virtualcamera/Effects/Effect.gd"

class_name Follow

export var follow_target : NodePath
export(float, 0.0, 1.0) var follow_lerp_t : float = 1.0
export var follow_offset : Vector3 = Vector3.ZERO

func has_follow_target() -> bool:
  return not follow_target.is_empty()
  
func _physics_process(delta : float):
  if not self.follow_target.is_empty():
    var target = get_node_or_null(self.follow_target)
    if target != null:
      global_transform.origin = global_transform.origin.linear_interpolate(target.global_transform.origin + self.follow_offset, self.follow_lerp_t)
    else:
      self.follow_target = NodePath()
