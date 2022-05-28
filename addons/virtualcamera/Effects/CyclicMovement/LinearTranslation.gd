extends "res://addons/virtualcamera/Effects/CyclicMovement/CyclicMovement.gd"

class_name LinearTranslation

export var scalar_coefficient : Vector3 = Vector3.ZERO
export var bounce : bool = false

onready var base_translation : Vector3 = global_transform.origin

func f(t):
	return (t - floor(t)) * 2 - 1

func g(t):
	return abs(2 * f(0.5 * (t - 1))) - 1

func _physics_process(delta : float):
	var t = time_offset + time
	if bounce:
		translation = base_translation + Vector3(g(t.x), g(t.y), g(t.z)) * scalar_coefficient
	else:
		translation = base_translation + Vector3(f(t.x), f(t.y), f(t.z)) * scalar_coefficient
