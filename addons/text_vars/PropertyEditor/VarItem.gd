tool
extends HBoxContainer

const POPUP_ITEM_INDEXES: = {"String": 0, "Color": 1, "Int": 2, "Remove": 4}

var value_edit_scene: = preload("../TypeEditors/ValueEdit.tscn")

var editor_interface: EditorInterface
var value setget, _get_value
var var_name: String

var value_edit: Control
onready var popup_menu: = $MenuButton.get_popup() as PopupMenu

signal value_changed()
signal rename(new_name)
signal remove()

func _ready() -> void:
	value_edit = value_edit_scene.instance()
	value_edit.editor_interface = editor_interface
	value_edit.value = value
	add_child(value_edit)
	move_child(value_edit, 1)
	value_edit.connect("value_changed", self, "_on_ValueEdit_value_changed")
	
	var editor_theme: = editor_interface.get_base_control().theme
	$NameEdit.text = var_name
	$MenuButton.icon = editor_theme.get_icon("menu_highlight", "TabContainer")
	
	popup_menu.add_icon_radio_check_item(editor_theme.get_icon("String", "EditorIcons"), "String")
	popup_menu.add_icon_radio_check_item(editor_theme.get_icon("Color", "EditorIcons"), "Color")
	popup_menu.add_icon_radio_check_item(editor_theme.get_icon("int", "EditorIcons"), "Int")
	popup_menu.add_separator()
	popup_menu.add_icon_item(editor_theme.get_icon("Remove", "EditorIcons"), "Remove")
	
	popup_menu.set_item_checked(value_edit.type, true)
	popup_menu.connect("index_pressed", self, "_on_popup_menu_index_pressed")

func _get_value():
	return value_edit.value

func _on_ValueEdit_value_changed() -> void:
	emit_signal("value_changed")

func _on_NameEdit_text_entered(new_text: String) -> void:
	emit_signal("rename", new_text)

func _on_NameEdit_focus_exited() -> void:
	$NameEdit.text = var_name

func _on_RemoveButton_pressed() -> void:
	emit_signal("remove")

func _on_popup_menu_index_pressed(index: int) -> void:
	if index == POPUP_ITEM_INDEXES["Remove"]:
		emit_signal("remove")
	else:
		if value_edit.type != index:
			value_edit.type = index
			emit_signal("value_changed")
		for i in 3:
			popup_menu.set_item_checked(i, index == i)
