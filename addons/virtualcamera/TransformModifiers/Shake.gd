tool
extends "res://addons/virtualcamera/TransformModifiers/TransformModifier.gd"

class_name Shake

export var noise : OpenSimplexNoise
export var speed : float = 1.0
export var strength_translation : Vector3 = Vector3.ZERO
export var strength_rotation : Vector3 = Vector3.ZERO
var time : float = 0.0

func _ready():
	if not noise:
		noise = OpenSimplexNoise.new()
		noise.seed = get_instance_id()
		noise.octaves = 4
		noise.persistence = 0.8

func _physics_process(delta : float):
	if noise:
		time += delta * self.speed * 100
		translation = Vector3(
			noise.get_noise_1d(time) * self.strength_translation.x,
			noise.get_noise_1d(time - 10000) * self.strength_translation.y,
			noise.get_noise_1d(time - 20000) * self.strength_translation.z
			)
		rotation = Vector3(
			deg2rad(noise.get_noise_1d(time - 30000) * self.strength_rotation.x),
			deg2rad(noise.get_noise_1d(time - 40000) * self.strength_rotation.y),
			deg2rad(noise.get_noise_1d(time - 50000) * self.strength_rotation.z)
			)

