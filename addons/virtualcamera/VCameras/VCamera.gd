@tool
@icon("res://addons/virtualcamera/VCameras/VCamera.svg")
class_name VCamera
extends Node3D


@export var priority : int = 10 # (int, 0, 1024)
@export var enabled : bool = true

@export var transition_time : float = 1.0
@export var transition_ease : float = -2.0 # (float, EASE)

@export var fov : float = 70.0: set = set_fov
func set_fov(value : float) -> void:
	fov = value
	if Engine.is_editor_hint():
		rebuild_geom()

@export var near : float = 0.05 # (float, EXP, 0.01, 8192)
@export var far : float = 100.0 # (float, EXP, 0.01, 8192)

func _ready():
	if Engine.is_editor_hint():
		rebuild_geom()
		set_process_priority(-1000)
	add_to_group("vcamera", true)

func _process(delta : float):
	if Engine.is_editor_hint():
		rebuild_geom()

# Gizmos
var geom : ImmediateMesh
var geomNode : MeshInstance3D
const color = Color(0.2, 0.6, 0.2)
func instantiate_geom():
	if Engine.is_editor_hint():
		if geom == null:
			geom = ImmediateMesh.new()
		if geomNode == null:
			geomNode = get_node_or_null("geom")
			if geomNode == null:
				geomNode = MeshInstance3D.new()
				geomNode.set_name("geom")
				add_child(geomNode)
				geomNode.mesh = geom

func init_geom():
	if Engine.is_editor_hint() :
		geom.clear_surfaces()
		var mat = StandardMaterial3D.new()
		mat.flags_unshaded = true
		mat.vertex_color_use_as_albedo = true
		var z_len = cos(deg_to_rad(fov / 2))
		var xy_len = sin(deg_to_rad(fov / 2))
		geomNode.material_override = mat
		
		# Cone
		geom.surface_begin(Mesh.PRIMITIVE_LINES)
		geom.surface_set_color(color)
		geom.surface_add_vertex(Vector3(0.0, 0.0, 0.0))
		geom.surface_add_vertex(Vector3(xy_len, xy_len, -z_len))
		geom.surface_add_vertex(Vector3(0.0, 0.0, 0.0))
		geom.surface_add_vertex(Vector3(-xy_len, xy_len, -z_len))
		geom.surface_add_vertex(Vector3(0.0, 0.0, 0.0))
		geom.surface_add_vertex(Vector3(-xy_len, -xy_len, -z_len))
		geom.surface_add_vertex(Vector3(0.0, 0.0, 0.0))
		geom.surface_add_vertex(Vector3(xy_len, -xy_len, -z_len))
		geom.surface_end()
		
		# Square
		geom.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
		geom.surface_set_color(color)
		geom.surface_add_vertex(Vector3(xy_len, xy_len, -z_len))
		geom.surface_add_vertex(Vector3(-xy_len, xy_len, -z_len))
		geom.surface_add_vertex(Vector3(-xy_len, -xy_len, -z_len))
		geom.surface_add_vertex(Vector3(xy_len, -xy_len, -z_len))
		geom.surface_add_vertex(Vector3(xy_len, xy_len, -z_len))
		geom.surface_end()
		
		# Up pointer
		geom.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
		geom.surface_set_color(color)
		geom.surface_add_vertex(Vector3(xy_len * -0.25, xy_len, -z_len))
		geom.surface_add_vertex(Vector3(0.0, xy_len * 1.5, -z_len))
		geom.surface_add_vertex(Vector3(xy_len * 0.25, xy_len, -z_len))
		geom.surface_end()

func rebuild_geom():
	instantiate_geom()
	init_geom()
