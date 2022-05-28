extends "res://addons/virtualcamera/TransformModifiers/UniformMovement/UniformMovement.gd"

class_name UniformRotation

export var degrees_per_second : Vector3 = Vector3.ZERO

func _physics_process(delta : float):
	rotation += deg2rad(1.0) * degrees_per_second * delta
