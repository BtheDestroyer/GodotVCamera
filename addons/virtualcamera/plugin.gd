tool
extends EditorPlugin

const VCAMERA_PREVIEW_SCENE = preload("res://addons/virtualcamera/VCameras/PreviewPlugin/VCameraPreviewPlugin.tscn")
var vcamera_preview

var follow_gizmo_plugin = preload("res://addons/virtualcamera/TransformModifiers/Gizmos/FollowGizmoPlugin.gd").new()

func _enter_tree():
	# Usage Tracking
	# See: https://github.com/BtheDestroyer/GodotVCamera#privacy-notice
	var http = HTTPRequest.new()
	add_child(http)
	var project_hash = ProjectSettings.get_setting("application/config/name").sha256_text()
	http.request("https://pluginstats.brycedixon.dev/", [], true, HTTPClient.METHOD_POST, JSON.print({plugin="VCamera", project=project_hash}))
	# Usage Tracking
	
	add_spatial_gizmo_plugin(follow_gizmo_plugin)

func handles(object: Object) -> bool:
	return object is VCamera

func edit(object: Object) -> void:
	close_vcamera_preview()
	vcamera_preview = VCAMERA_PREVIEW_SCENE.instance()
	vcamera_preview.target_vcamera = object
	vcamera_preview.connect("closing", self, "close_vcamera_preview")
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, vcamera_preview)

func close_vcamera_preview() -> void:
	if is_instance_valid(vcamera_preview):
		remove_control_from_docks(vcamera_preview)
		vcamera_preview.queue_free()

func _exit_tree():
	close_vcamera_preview()
	remove_spatial_gizmo_plugin(follow_gizmo_plugin)
