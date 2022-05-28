extends "res://addons/virtualcamera/TransformModifiers/CyclicMovement/CyclicMovement.gd"

class_name SineTranslation

export var scalar_coefficient : Vector3 = Vector3.ZERO

onready var base_translation : Vector3 = global_transform.origin

func _physics_process(delta : float):
	var t = time_offset + time
	translation = base_translation + Vector3(
		sin(t.x * 2 * PI) * scalar_coefficient.x,
		sin(t.y * 2 * PI) * scalar_coefficient.y,
		sin(t.z * 2 * PI) * scalar_coefficient.z
		)
