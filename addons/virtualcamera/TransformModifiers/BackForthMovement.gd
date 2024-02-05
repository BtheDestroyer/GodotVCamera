@tool
extends "res://addons/virtualcamera/TransformModifiers/TransformModifier.gd"

class_name BackForthMovement

@export_range(0.0,60.0) var duration_forth : float = 1.0 # (float, 0.0, 60.0)
@export_range(0.0,60.0) var duration_back : float = 1.0 # (float, 0.0, 60.0)
@export_range(0.0,120.0) var time_offset : float = 0.0 # (float, 0.0, 120.0)

@export_exp_easing var ease_forth : float = -2.0 # (float, EASE)
@export_exp_easing var ease_back : float = -2.0 # (float, EASE)

@export_range(0.1,10.0) var time_factor : float = 1.0 # (float, 0.1, 10.0)
@export_range(0.1,1.0) var strength_factor : float = 1.0 # (float, 0.1, 1.0)

@export var translate_by : Vector3 = Vector3.ZERO
@export var rotate_degrees : Vector3 = Vector3.ZERO
@export var scale_by : Vector3 = Vector3.ONE

var time : float = time_offset

func _physics_process(delta : float):
	time += delta * time_factor
	time = fposmod(time, duration_forth + duration_back)
	
	var t : float
	if time < duration_forth:
		t = time / duration_forth
		t = ease(t, ease_forth)
	else:
		t = (time - duration_forth) / duration_back
		t = 1 - ease(t, ease_back)
	
	var initial_position : Vector3
	var new_rotation := Quaternion.IDENTITY
	var parent = get_parent() as Node3D
	if parent:
		initial_position = parent.global_transform.origin
		new_rotation = parent.global_transform.basis.get_rotation_quaternion()
	
	global_transform.origin = initial_position + translate_by * t * strength_factor
	
	new_rotation *= Quaternion(Vector3.RIGHT, t * deg_to_rad(rotate_degrees.x))
	new_rotation *= Quaternion(Vector3.UP, t * deg_to_rad(rotate_degrees.y))
	new_rotation *= Quaternion(Vector3.BACK, t * deg_to_rad(rotate_degrees.z))
	global_transform.basis = Basis(new_rotation)
	
	scale = Vector3.ONE.lerp(scale_by, t)
