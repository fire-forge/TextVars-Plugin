tool
extends Control

var editor_interface: EditorInterface

var value: Color setget _set_value

onready var editor_settings: = editor_interface.get_editor_settings() as EditorSettings
onready var color_rect: = $HBox/HBox/ColorRect as ColorRect
onready var color_picker_button: = $ColorPickerButton as ColorPickerButton
var color_picker: ColorPicker

signal value_changed()

# Functions #

func _ready() -> void:
	self.value = value
	$Panel.add_stylebox_override("panel", editor_interface.get_base_control().theme.get_stylebox("normal", "Button"))
	_update_color()

# Private #

func _load_presets_to_editor() -> void:
	if color_picker:
		editor_settings.set_project_metadata("color_picker", "presets", color_picker.get_presets())

func _update_presets_from_editor() -> void:
	if color_picker:
		var presets: PoolColorArray = editor_settings.get_project_metadata("color_picker", "presets", PoolColorArray())
		if presets:
			for color in color_picker.get_presets(): # Clear current presets
				color_picker.erase_preset(color)
			for color in presets:
				color_picker.add_preset(color)

func _update_color() -> void:
	if color_picker_button:
		value = color_picker_button.color
		color_rect.color = value
		$HBox/ColorCode.text = "#" + value.to_html(value.a != 1)
		emit_signal("value_changed")

func _set_value(new_value: Color) -> void:
	value = new_value
	$ColorPickerButton.color = value
	_update_color()

# Connections #

func _on_ColorPicker_visibility_changed() -> void:
	if color_picker.visible:
		var default_mode = editor_settings.get_setting("interface/inspector/default_color_picker_mode")
		color_picker.hsv_mode = default_mode == 1
		color_picker.raw_mode = default_mode == 2
		_update_presets_from_editor()
	else:
		_load_presets_to_editor()

func _on_ColorPickerButton_color_changed(_color: Color) -> void:
	_update_color()

func _on_ColorPickerButton_picker_created() -> void:
	color_picker = color_picker_button.get_picker()
	color_picker.connect("visibility_changed", self, "_on_ColorPicker_visibility_changed")
