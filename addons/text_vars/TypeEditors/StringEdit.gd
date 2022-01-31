tool
extends LineEdit

var value: String setget _set_value

signal value_changed()

func _ready() -> void:
	self.value = value

func _set_value(new_value: String) -> void:
	value = new_value
	text = value

func _on_StringEdit_text_changed(new_text: String) -> void:
	value = new_text
	emit_signal("value_changed")
