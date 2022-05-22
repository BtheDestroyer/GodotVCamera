tool
extends Spatial

class_name VCamera, "res://addons/virtualcamera/VCameras/VCamera.svg"

export(int, 0, 1024) var priority : int = 10

export var transition_time : float = 1.0
enum TransitionMode { Linear, SmoothStart, SmoothStop, SmoothStep }
export(int, "Linear", "Smooth Start", "Smooth Stop", "Smooth Step") var transition_mode : int = TransitionMode.Linear
export var transition_power : float =  2.0

func transition_mode_is_nonlinear():
  return transition_mode != TransitionMode.Linear

func _ready():
  if Engine.editor_hint:
    rebuild_geom()
    set_process_priority(-1000)
  else:
    add_to_group("vcamera")

func _process(delta : float):
  if Engine.editor_hint:
    rebuild_geom()

# Gizmos
var geom : ImmediateGeometry
const color = Color(0.2, 0.6, 0.2)
const geomlen = sqrt(0.5)
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
    geom.material_override = mat
    geom.begin(Mesh.PRIMITIVE_LINES)
    geom.set_color(color)
    geom.add_vertex(Vector3(0.0, 0.0, 0.0))
    geom.add_vertex(Vector3(geomlen, geomlen, -geomlen))
    geom.add_vertex(Vector3(0.0, 0.0, 0.0))
    geom.add_vertex(Vector3(-geomlen, geomlen, -geomlen))
    geom.add_vertex(Vector3(0.0, 0.0, 0.0))
    geom.add_vertex(Vector3(-geomlen, -geomlen, -geomlen))
    geom.add_vertex(Vector3(0.0, 0.0, 0.0))
    geom.add_vertex(Vector3(geomlen, -geomlen, -geomlen))
    geom.end()
    geom.begin(Mesh.PRIMITIVE_LINE_STRIP)
    geom.set_color(color)
    geom.add_vertex(Vector3(geomlen, geomlen, -geomlen))
    geom.add_vertex(Vector3(-geomlen, geomlen, -geomlen))
    geom.add_vertex(Vector3(-geomlen, -geomlen, -geomlen))
    geom.add_vertex(Vector3(geomlen, -geomlen, -geomlen))
    geom.add_vertex(Vector3(geomlen, geomlen, -geomlen))
    geom.end()

func rebuild_geom():
  instantiate_geom()
  init_geom()
