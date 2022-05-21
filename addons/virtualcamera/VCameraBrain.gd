tool
extends Camera

class_name VCameraBrain, "res://addons/virtualcamera/VCameraBrain.svg"

var last_active_vcamera : VCamera = null
var transition_time : float = 0.0
var transition_start : Transform

func get_highest_priority_vcamera() -> VCamera:
  var cam = last_active_vcamera
  var highest_priority = 0 if cam == null else cam.priority
  var vcams = get_tree().get_nodes_in_group("vcamera")
  for vcam in vcams:
    if vcam is VCamera and (cam == null or vcam.priority > highest_priority):
      cam = vcam
      highest_priority = vcam.priority
  return cam

func begin_transition(vcam : VCamera):
  transition_start = global_transform
  transition_time = 0.0 if last_active_vcamera != null else vcam.transition_time
  last_active_vcamera = vcam

func process_transition(vcam : VCamera):
  var t = transition_time / vcam.transition_time
  match vcam.transition_mode:
    VCamera.TransitionMode.Linear:
      t = NonlinearTransformations.linear(t)
    VCamera.TransitionMode.SmoothStart:
      t = NonlinearTransformations.smooth_start(t, vcam.transition_power)
    VCamera.TransitionMode.SmoothStop:
      t = NonlinearTransformations.smooth_stop(t, vcam.transition_power)
    VCamera.TransitionMode.SmoothStep:
      t = NonlinearTransformations.smooth_step(t, vcam.transition_power)
  global_transform = transition_start.interpolate_with(vcam.global_transform, t)

func snap_transition(vcam : VCamera):
  transition_time = vcam.transition_time
  global_transform = vcam.global_transform

func _physics_process(delta : float):
  var vcam = get_highest_priority_vcamera()
  if vcam == null:
    return
  if not is_instance_valid(last_active_vcamera):
    last_active_vcamera = null
  if last_active_vcamera != vcam:
    begin_transition(vcam)
  transition_time = min(transition_time + delta, vcam.transition_time)
  if transition_time < vcam.transition_time:
    process_transition(vcam)
  else:
    snap_transition(vcam)
