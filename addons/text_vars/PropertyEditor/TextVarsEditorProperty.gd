tool
extends EditorProperty

var side_editor_scene: = preload("SideEditor.tscn")
var main_editor_scene: = preload("MainEditor.tscn")

var editor_interface: EditorInterface

var main_editor: Control
var side_editor: Control

onready var object: = get_edited_object() as TextVars

func _ready() -> void:
	if editor_interface.get_editor_settings().get_setting("interface/inspector/capitalize_properties"):
		label = "TextVars"
	
	main_editor = main_editor_scene.instance()
	main_editor.editor_interface = editor_interface
	main_editor.object = object
	main_editor.visible = false
	add_child(main_editor)
	main_editor.connect("set_var", self, "_on_TextVarsEditor_set_var")
	main_editor.connect("rename_var", self, "_on_TextVarsEditor_rename_var")
	main_editor.connect("remove_var", self, "_on_TextVarsEditor_remove_var")
	
	side_editor = side_editor_scene.instance()
	side_editor.editor_interface = editor_interface
	add_child(side_editor)
	side_editor.connect("toggle_edit", self, "_on_SideEditor_toggle_edit")
	
	_update_text_vars()

func update_property() -> void:
	_update_text_vars()
	object._update_text()

func _update_text_vars() -> void:
	side_editor.items = object.text_vars.size()
	main_editor.update_vars_list()

func _emit_changed(text_vars: Dictionary) -> void:
	emit_changed("text_vars", text_vars) #, "", true)

func _on_SideEditor_toggle_edit(enabled: bool) -> void:
	main_editor.visible = enabled
	
	if enabled:
		set_bottom_editor(main_editor)
	else:
		set_bottom_editor(null)

func _on_TextVarsEditor_set_var(var_name: String, value) -> void:
	var text_vars: = object.text_vars.duplicate()
	text_vars[var_name] = value
	_emit_changed(text_vars)

func _on_TextVarsEditor_rename_var(current_name: String, new_name: String) -> void:
	var text_vars: = object.text_vars.duplicate()
	text_vars[new_name] = text_vars.get(current_name)
	text_vars.erase(current_name)
	_emit_changed(text_vars)

func _on_TextVarsEditor_remove_var(var_name: String) -> void:
	var text_vars: = object.text_vars.duplicate()
	text_vars.erase(var_name)
	_emit_changed(text_vars)
