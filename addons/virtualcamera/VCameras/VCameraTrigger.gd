extends Area

class_name VCameraTrigger

export(NodePath) var target_vcamera : NodePath
var overlapping_count : int = 0 setget set_overlapping_count

func _ready() -> void:
	connect("area_entered", self, "on_entered")
	connect("body_entered", self, "on_entered")
	connect("area_exited", self, "on_exited")
	connect("body_exited", self, "on_exited")

func set_overlapping_count(value : int):
	overlapping_count = value
	var vcamera : VCamera = get_node_or_null(self.target_vcamera) as VCamera
	if vcamera:
		vcamera.enabled = overlapping_count > 0

func on_entered(_area) -> void:
	self.overlapping_count += 1

func on_exited(_area) -> void:
	self.overlapping_count -= 1
