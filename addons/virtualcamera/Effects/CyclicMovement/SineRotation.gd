extends "res://addons/virtualcamera/Effects/CyclicMovement/CyclicMovement.gd"

class_name SineRotation

export var scalar_coefficient : Vector3 = Vector3.ZERO

onready var base_rotation : Quat = Quat(rotation)

func _physics_process(delta : float):
  var t = time_offset + time
  var new_rotation = Quat(Vector3.RIGHT, sin(t.x * 2 * PI) * deg2rad(scalar_coefficient.x))
  new_rotation *= Quat(Vector3.UP, sin(t.y * 2 * PI) * deg2rad(scalar_coefficient.y))
  new_rotation *= Quat(Vector3.BACK, sin(t.z * 2 * PI) * deg2rad(scalar_coefficient.z))
  rotation = (base_rotation * new_rotation).get_euler()
