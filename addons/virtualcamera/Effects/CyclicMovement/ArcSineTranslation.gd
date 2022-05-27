extends "res://addons/virtualcamera/Effects/CyclicMovement/CyclicMovement.gd"

class_name ArcSineTranslation

export var scalar_coefficient : Vector3 = Vector3.ZERO

onready var base_translation : Vector3 = global_transform.origin

func _physics_process(delta : float):
	var t = time_offset + time
	t.x -= floor(t.x)
	t.x = 2 * asin(t.x * 2 - 1) / PI
	t.y -= floor(t.y)
	t.y = 2 * asin(t.y * 2 - 1) / PI
	t.z -= floor(t.z)
	t.z = 2 * asin(t.z * 2 - 1) / PI
	translation = base_translation + t * scalar_coefficient
