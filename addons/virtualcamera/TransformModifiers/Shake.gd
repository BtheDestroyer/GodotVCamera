@tool
extends "res://addons/virtualcamera/TransformModifiers/TransformModifier.gd"

class_name Shake

@export var noise : FastNoiseLite
@export var speed : float = 1.0

@export_range(0,1) var intensity : float = 1.0 # (float, 0, 1)
@export_exp_easing var intensity_curve : float = 2.0 # (float, EASE)
@export var intensity_decrease_rate : float = 0.0

@export var translation_strength : Vector3 = Vector3.ZERO
@export var rotation_strength : Vector3 = Vector3.ZERO

var time : float = 0.0

func _ready():
	if not noise:
		noise = FastNoiseLite.new()
		noise.seed = get_instance_id()
		noise.fractal_octaves = 4
		noise.fractal_gain = 0.8

const DEG2RAD = TAU / 360

func _physics_process(delta : float):
	if noise:
		time += delta * speed * 100
		
		if not Engine.is_editor_hint():
			intensity = max(0, intensity - intensity_decrease_rate * delta)
		var amplitude = ease(intensity, intensity_curve)
		
		position = Vector3(noise.get_noise_1d(time), noise.get_noise_1d(time - 10000), noise.get_noise_1d(time - 20000))
		position *= translation_strength * amplitude
		
		rotation = Vector3(noise.get_noise_1d(time - 30000), noise.get_noise_1d(time - 40000), noise.get_noise_1d(time - 50000))
		rotation *= rotation_strength * DEG2RAD * amplitude

