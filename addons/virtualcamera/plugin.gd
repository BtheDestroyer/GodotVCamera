tool
extends EditorPlugin

func _enter_tree():
	# Usage Tracking
	# See: https://github.com/BtheDestroyer/GodotVCamera#privacy-notice
	var http = HTTPRequest.new()
	add_child(http)
	var project_hash = ProjectSettings.get_setting("application/config/name").sha256_text()
	http.request("https://pluginstats.brycedixon.dev/", [], true, HTTPClient.METHOD_POST, JSON.print({plugin="VCamera", project=project_hash}))
	# Usage Tracking

func _exit_tree():
	pass
