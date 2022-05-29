tool
extends EditorPlugin

func _enter_tree():
	# Usage Tracking
	# See: https://github.com/BtheDestroyer/GodotVCamera#privacy-notice
	var http = HTTPRequest.new()
	add_child(http)
	http.request("https://pluginstats.brycedixon.dev/", [], true, HTTPClient.METHOD_POST, JSON.print({plugin="VCamera", project=ProjectSettings.get_setting("application/config/name")}))
	# Usage Tracking

func _exit_tree():
	pass
