tool
extends Control

var editor_interface: EditorInterface
var items: int setget _set_items

onready var icons: = [
	editor_interface.get_base_control().theme.get_icon("GuiTreeArrowDown", "EditorIcons"),
	editor_interface.get_base_control().theme.get_icon("GuiTreeArrowUp", "EditorIcons")
]
onready var edit_button: = $EditButton as Button

signal toggle_edit(enabled)

func _ready() -> void:
	edit_button.icon = icons.front()

func _set_items(value: int) -> void:
	items = value
	$Label.text = String(value) + " " + ("Variable" if value == 1 else "Variables")

func _on_EditButton_toggled(button_pressed: bool) -> void:
	edit_button.icon = icons[int(button_pressed)]
	emit_signal("toggle_edit", button_pressed)
