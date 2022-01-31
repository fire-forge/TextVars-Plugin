tool
extends EditorPlugin

var inspector_plugin: = preload("InspectorPlugin.gd").new() as EditorInspectorPlugin

func _enter_tree() -> void:
	inspector_plugin.editor_interface = get_editor_interface()
	add_inspector_plugin(inspector_plugin)

func _exit_tree() -> void:
	remove_inspector_plugin(inspector_plugin)
