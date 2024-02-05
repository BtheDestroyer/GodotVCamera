extends "res://addons/virtualcamera/TransformModifiers/UniformMovement/UniformMovement.gd"

class_name UniformTranslation

@export var translation_per_second : Vector3 = Vector3.ZERO

func _physics_process(delta : float):
	position += translation_per_second * delta
