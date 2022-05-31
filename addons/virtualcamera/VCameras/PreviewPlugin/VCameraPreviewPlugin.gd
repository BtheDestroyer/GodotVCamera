tool
extends Control

signal closing

onready var aspect_option : OptionButton = $VBoxContainer/HBoxContainer/AspectOptionButton
onready var aspect_container : AspectRatioContainer = $VBoxContainer/AspectRatioContainer
onready var keep_option : OptionButton = $VBoxContainer/HBoxContainer/KeepOptionButton
onready var camera : Camera = $VBoxContainer/AspectRatioContainer/ViewportContainer/Viewport/Camera
var target_vcamera : VCamera

var aspect_ratios = [ 
	{ name = "16:9 Standard HD", ratio = 16.0 / 9.0 }, 
	{ name = "4:3 Standard SD", ratio = 4.0 / 3.0 }, 
	{ name = "9:16 Standard Portrait", ratio = 9.0 / 16.0 }, 
	{ name = "16:9 Split Vertical", ratio = 16.0 / 9.0 / 2 }, 
	{ name = "16:9 Split Horizontal", ratio = 16.0 / 9.0 * 2 }, 
]

func _ready() -> void:
	aspect_option.clear()
	for aspect_ratio in aspect_ratios:
		aspect_option.add_item(aspect_ratio.name)
	keep_option.clear()
	keep_option.add_item("FOV: Keep Width")
	keep_option.add_item("FOV: Keep Height")
	keep_option.selected = 1
	
	target_vcamera.connect("tree_exited", self, "_on_CloseButton_pressed")
	name = target_vcamera.name + " Preview"

func _process(_delta: float) -> void:
	if is_instance_valid(target_vcamera):
		camera.global_transform = target_vcamera.global_transform
		camera.fov = target_vcamera.fov
		camera.near = target_vcamera.near
		camera.far = target_vcamera.far
	else:
		emit_signal("closing")

func _on_AspectOptionButton_item_selected(index: int) -> void:
	aspect_container.ratio = aspect_ratios[index].ratio

func _on_KeepOptionButton_item_selected(index: int) -> void:
	camera.keep_aspect = index

func _on_CloseButton_pressed() -> void:
	emit_signal("closing")

