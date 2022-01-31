tool
extends Control
class_name TextVars

const FORMAT_STRING: = "{_}"

export(String, MULTILINE) var source_text: String setget _set_source_text
export var text_vars: Dictionary setget _set_text_vars

var text_var_strings: Dictionary
var _text_variable_name: String = {"Label": "text", "RichTextLabel": "bbcode_text"}.get(get_class(), "")

# Functions #

func _ready() -> void:
	if get_class() == "RichTextLabel":
		set("bbcode_enabled", true)
	
	_update_all_var_strings()
	_update_text()

# Public #

func set_var(key: String, value) -> void:
	text_vars[key] = value
	text_var_strings[key] = _get_var_string(value)
	_update_text()

func remove_var(key: String) -> void:
	text_vars.erase(key)
	text_var_strings.erase(key)
	_update_text()

func get_var(key: String):
	return text_vars.get(key)

# Local / Plugin #

func _update_text() -> void:
	set(_text_variable_name, source_text.format(text_var_strings, FORMAT_STRING))

func _update_all_var_strings() -> void:
	text_var_strings = text_vars.duplicate()
	for key in text_var_strings.keys():
		if key is String:
			text_var_strings[key] = _get_var_string(text_vars[key])
		else:
			text_var_strings.erase(key)

func __is_text_vars__() -> void:
	pass

static func _get_var_string(value) -> String:
	if value is String:
		return value
	elif value is Color:
		return value.to_html(value.a != 1)
	else:
		return str(value)

# Setget #

func _set_source_text(value: String) -> void:
	source_text = value
	_update_text()

func _set_text_vars(value: Dictionary) -> void:
	text_vars = value
	_update_all_var_strings()
	_update_text()
