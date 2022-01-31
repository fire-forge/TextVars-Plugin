tool
extends Control

var value: int setget _set_value

signal value_changed()

func _ready() -> void:
	self.value = value

func _set_value(new_value: int) -> void:
	value = new_value
	$SpinBox.value = value

func _on_SpinBox_value_changed(new_value: float) -> void:
	value = int(round(new_value))
	emit_signal("value_changed")
