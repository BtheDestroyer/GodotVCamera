extends EditorInspectorPlugin

class PreviewCamera:
	extends Camera
	
	var target_vcamera : VCamera
	
	func _process(_delta: float) -> void:
		if target_vcamera:
			global_transform = target_vcamera.global_transform
			fov = target_vcamera.fov
			near = target_vcamera.near
			far = target_vcamera.far

class CameraVierportContainer:
	extends ViewportContainer
	
	var aspect : float = 16.0 / 9.0
	
	func _process(_delta: float) -> void:
		rect_min_size.y = rect_size.x / aspect

var preview_camera : PreviewCamera

func can_handle(object: Object) -> bool:
	return object is VCamera

func parse_begin(object: Object) -> void:
	var vcamera : VCamera = object as VCamera
	
	preview_camera = PreviewCamera.new()
	preview_camera.target_vcamera = vcamera
	
	var viewport = Viewport.new()
	var viewport_container = CameraVierportContainer.new()
	viewport_container.stretch = true
	
	viewport.add_child(preview_camera)
	viewport_container.add_child(viewport)
	add_custom_control(viewport_container)
