extends EditorNode3DGizmoPlugin

func _has_gizmo(spatial: Node3D) -> bool:
	return spatial is Follow

func _init():
	create_material("main", Color(0.2, 0.4, 1))
	create_material("billboard", Color(0.2, 0.4, 1), true)
	create_handle_material("handles")

func _get_gizmo_name() -> String:
	return "Follow"
	
func _redraw(gizmo: EditorNode3DGizmo) -> void:
	gizmo.clear()
	
	var target : Follow = gizmo.get_node_3d()
	var lines : Array = []
	
	if target.lock_axes == 0b000:
		_add_distance_circles(lines, target, Vector3.FORWARD)
		gizmo.add_lines(PackedVector3Array(lines), get_material("billboard", gizmo), true)
	else:
		if (not target.lock_axes & 0b100) and (not target.lock_axes & 0b010):
			_add_distance_circles(lines, target, Vector3.RIGHT)
		if (not target.lock_axes & 0b100) and (not target.lock_axes & 0b001):
			_add_distance_circles(lines, target, Vector3.UP)
		if (not target.lock_axes & 0b010) and (not target.lock_axes & 0b001):
			_add_distance_circles(lines, target, Vector3.FORWARD)
		
		if target.lock_axes & 0b100 and target.lock_axes & 0b010:
			_add_distance_lines(lines, target, Vector3.RIGHT)
			_add_distance_lines(lines, target, Vector3.LEFT)
		if target.lock_axes & 0b100 and target.lock_axes & 0b001:
			_add_distance_lines(lines, target, Vector3.UP)
			_add_distance_lines(lines, target, Vector3.DOWN)
		if target.lock_axes & 0b010 and target.lock_axes & 0b001:
			_add_distance_lines(lines, target, Vector3.FORWARD)
			_add_distance_lines(lines, target, Vector3.BACK)
		
		gizmo.add_lines(PackedVector3Array(lines), get_material("main", gizmo))

func _add_distance_circles(lines : Array, target : Follow, normal : Vector3):
	_add_circle(lines, Vector3.ZERO, target.min_distance, normal)
	_add_dashed_circle(lines, Vector3.ZERO, target.min_distance + target.min_distance_push_margin, normal)
	_add_circle(lines, Vector3.ZERO, target.max_distance, normal)
	_add_dashed_circle(lines, Vector3.ZERO, target.max_distance - target.max_distance_push_margin, normal)

func _add_distance_lines(lines : Array, target : Follow, direction : Vector3):
	_add_dashed_line(lines, direction * target.min_distance,
		direction * (target.min_distance + target. min_distance_push_margin))
	lines.append(direction * (target.min_distance + target.min_distance_push_margin))
	lines.append(direction * (target.max_distance - target.max_distance_push_margin))
	_add_dashed_line(lines, direction * target.max_distance,
		direction * (target.max_distance - target.max_distance_push_margin))

func _add_circle(lines : Array, offset : Vector3, radius : float, normal : Vector3 = Vector3.UP, segment_length : float = .3):
	if radius <= 0:
		return
	
	var vertices : int = TAU / segment_length * radius
	var vertex_pos = normal.cross(Vector3.FORWARD if normal != Vector3.FORWARD else Vector3.UP) * radius
	var vertex_angle = TAU / vertices
	
	for i in vertices:
		lines.append(Quaternion(normal, vertex_angle * i) * vertex_pos + offset)
		lines.append(Quaternion(normal, vertex_angle * (i + 1)) * vertex_pos + offset)

func _add_dashed_circle(lines : Array, offset : Vector3, radius : float, normal : Vector3 = Vector3.UP, segment_length : float = .3):
	if radius <= 0:
		return
	
	var vertices : int = TAU / segment_length * radius
	vertices += vertices % 2 # Ensure even amount
	var vertex_pos = normal.cross(Vector3.FORWARD if normal != Vector3.FORWARD else Vector3.UP) * radius
	var vertex_angle = TAU / vertices
	
	for i in range(0, vertices, 1):
		lines.append(Quaternion(normal, vertex_angle * i) * vertex_pos + offset)

func _add_dashed_line(lines : Array, from : Vector3, to : Vector3, segment_length : float = .1) -> void:
	var direction : Vector3 = to - from
	var direction_length = direction.length()
	if direction_length == 0:
		return
	
	var vertices : int = direction_length / segment_length
	vertices += vertices % 2 # Ensure even amount
	segment_length = direction_length / vertices
	direction = direction.normalized() * segment_length
	
	for i in range(0, vertices, 1):
		lines.append(from + direction * i)

