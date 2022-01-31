tool
extends Control

const EDIT_SCENES: = [
	preload("StringEdit.tscn"),
	preload("ColorEdit.tscn"),
	preload("IntEdit.tscn")
]

var editor_interface: EditorInterface

var value setget _set_value, _get_value
var type: int setget _set_type
var edit: Control

signal value_changed()

func _ready() -> void:
	if not edit:
		_create_edit()

func _set_value(new_value):
	value = new_value
	
	var prev_type: = type
	_update_type()
	if type != prev_type or not edit:
		_create_edit()
	edit.value = value

func _get_value():
	if edit:
		return edit.value
	else:
		return ""

func _set_type(new_type: int) -> void:
	new_type = int(clamp(new_type, 0, EDIT_SCENES.size() - 1))
	self.value = ["", Color(1, 1, 1), 0][new_type]

func _create_edit() -> void:
	if edit:
		edit.queue_free()
	
	edit = EDIT_SCENES[type].instance()
	edit.set("editor_interface", editor_interface)
	edit.connect("value_changed", self, "emit_signal", ["value_changed"])
	add_child(edit)

func _update_type() -> void:
	if value is String:
		type = 0
	elif value is Color:
		type = 1
	elif value is int:
		type = 2
	else:
		type = 0
		value = str(value)
