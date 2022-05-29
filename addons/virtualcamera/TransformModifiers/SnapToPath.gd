tool
extends TransformModifier

# This modifier takes the current position and snaps it to predefined path. Use for camera dolly -like movement.
class_name SnapToPath

export(NodePath) var target_path : NodePath
export(float, 0.0, 1.0) var lerp_t = 1.0
export var is_path_closed : bool = false
var current_offset : float = -1 # -1 = snap

func _physics_process(delta : float):
	var target_path_node : Path = get_node_or_null(self.target_path) as Path
	if target_path_node != null and target_path_node.curve != null:
		var initial_position : Vector3
		if get_parent() as Spatial:
			initial_position = get_parent().global_transform.origin
		initial_position = target_path_node.global_transform.xform_inv(initial_position)
		var new_offset : float = target_path_node.curve.get_closest_offset(initial_position)
		if self.current_offset < 0:
			self.current_offset = new_offset
		else:
			if not self.is_path_closed:
				self.current_offset = lerp(self.current_offset, new_offset, self.lerp_t)
			else:
				var curve_length : float = target_path_node.curve.get_baked_length()
				if self.current_offset - new_offset < curve_length * -.5:
					new_offset -= curve_length
				elif new_offset - self.current_offset < curve_length * -.5:
					new_offset += curve_length
				self.current_offset = fposmod(lerp(self.current_offset, new_offset, self.lerp_t), curve_length)
		global_transform.origin = target_path_node.global_transform.xform(target_path_node.curve.interpolate_baked(self.current_offset))
