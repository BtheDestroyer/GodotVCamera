extends "res://addons/virtualcamera/Effects/CyclicMovement/CyclicMovement.gd"

class_name LinearRotation

export var scalar_coefficient : Vector3 = Vector3.ZERO
export var bounce : bool = false

onready var base_rotation : Quat = Quat(rotation)

func f(t):
	return (t - floor(t)) * 2 - 1

func g(t):
	return abs(2 * f(0.5 * (t - 1))) - 1

func _physics_process(delta : float):
	var t = time_offset + time
	var new_rotation = Quat.IDENTITY;
	
	if bounce:
		new_rotation *= Quat(Vector3.RIGHT, g(t.x) * deg2rad(scalar_coefficient.x))
		new_rotation *= Quat(Vector3.UP, g(t.y) * deg2rad(scalar_coefficient.y))
		new_rotation *= Quat(Vector3.BACK, g(t.z) * deg2rad(scalar_coefficient.z))
	else:
		new_rotation *= Quat(Vector3.RIGHT, f(t.x) * deg2rad(scalar_coefficient.x))
		new_rotation *= Quat(Vector3.UP, f(t.y) * deg2rad(scalar_coefficient.y))
		new_rotation *= Quat(Vector3.BACK, f(t.z) * deg2rad(scalar_coefficient.z))
	rotation = (base_rotation * new_rotation).get_euler()
