extends "res://addons/virtualcamera/TransformModifiers/CyclicMovement/CyclicMovement.gd"

class_name ArcSineRotation

export var scalar_coefficient : Vector3 = Vector3.ZERO

onready var base_rotation : Quat = Quat(rotation)

func _physics_process(delta : float):
	var t = time_offset + time
	t.x -= floor(t.x)
	t.x = 2 * asin(t.x * 2 - 1) / PI
	t.y -= floor(t.y)
	t.y = 2 * asin(t.y * 2 - 1) / PI
	t.z -= floor(t.z)
	t.z = 2 * asin(t.z * 2 - 1) / PI
	var new_rotation = Quat(Vector3.RIGHT, t.x * deg2rad(scalar_coefficient.x))
	new_rotation *= Quat(Vector3.UP, t.y * deg2rad(scalar_coefficient.y))
	new_rotation *= Quat(Vector3.BACK, t.z * deg2rad(scalar_coefficient.z))
	rotation = (base_rotation * new_rotation).get_euler()
