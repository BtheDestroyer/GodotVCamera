tool
extends EditorPlugin

var http : HTTPRequest = null

func _enter_tree():
 	http = HTTPRequest.new()
 	add_child(http)
 	http.request("https://pluginstats.brycedixon.dev/", [], true, HTTPClient.METHOD_POST, JSON.print({plugin="VCamera", project=ProjectSettings.get_setting("application/config/name")}))

func _exit_tree():
	pass
