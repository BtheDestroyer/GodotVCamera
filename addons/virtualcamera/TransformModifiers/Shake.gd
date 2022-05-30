tool
extends "res://addons/virtualcamera/TransformModifiers/TransformModifier.gd"

class_name Shake

export var noise : OpenSimplexNoise
export var shake_speed : float = 1.0
export var shake_strength_translation : Vector3 = Vector3.ZERO
export var shake_strength_rotation : Vector3 = Vector3.ZERO
var shake_time : float = 0.0

func _ready():
	if not noise:
		noise = OpenSimplexNoise.new()
		noise.seed = get_instance_id()
		noise.octaves = 4
		noise.persistence = 0.8

func _physics_process(delta : float):
	if noise:
		shake_time += delta * self.shake_speed * 100
		translation = Vector3(
			noise.get_noise_1d(shake_time) * self.shake_strength_translation.x,
			noise.get_noise_1d(shake_time - 10000) * self.shake_strength_translation.y,
			noise.get_noise_1d(shake_time - 20000) * self.shake_strength_translation.z
			)
		rotation = Vector3(
			deg2rad(noise.get_noise_1d(shake_time - 30000) * self.shake_strength_rotation.x),
			deg2rad(noise.get_noise_1d(shake_time - 40000) * self.shake_strength_rotation.y),
			deg2rad(noise.get_noise_1d(shake_time - 50000) * self.shake_strength_rotation.z)
			)

