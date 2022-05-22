extends "res://addons/virtualcamera/Effects/Effect.gd"

class_name CyclicMovement
export var time_offset : Vector3 = Vector3.ZERO
export var time_coefficient : Vector3 = Vector3.ONE
var time : Vector3 = Vector3.ZERO

func _physics_process(delta : float):
  time += time_coefficient * delta
