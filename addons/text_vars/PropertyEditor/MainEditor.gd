tool
extends Control

var var_item_scene: = preload("VarItem.tscn")

var editor_interface: EditorInterface
var object: TextVars
var auto_names: = []
var auto_name_regex: = RegEx.new()

onready var name_edit: = $VBox/AddVarSection/VBox/NameEditRow/NameEdit as LineEdit
onready var auto_name_button: = $VBox/AddVarSection/VBox/NameEditRow/AutoNameButton as MenuButton
onready var auto_name_popup: = auto_name_button.get_popup() as PopupMenu
onready var value_edit: = $VBox/AddVarSection/VBox/ValueEditRow/ValueEdit as Control
onready var option_button: = $VBox/AddVarSection/VBox/ValueEditRow/OptionButton as OptionButton
onready var add_button: = $VBox/AddVarSection/VBox/AddRow/AddButton as Button
onready var vars_list: = $VBox/VarsListSection/VarsList as VBoxContainer
onready var no_vars_label: = $VBox/VarsListSection/NoVarsLabel as Label

var ready: = false

signal set_var(var_name, value)
signal rename_var(current_name, new_name)
signal remove_var(var_name)

func _ready() -> void:
	var editor_theme: = editor_interface.get_base_control().theme
	option_button.set_item_icon(0, editor_theme.get_icon("String", "EditorIcons"))
	option_button.set_item_icon(1, editor_theme.get_icon("Color", "EditorIcons"))
	option_button.set_item_icon(2, editor_theme.get_icon("int", "EditorIcons"))
	add_button.icon = editor_theme.get_icon("Add", "EditorIcons")
	$VBox/AddVarSection/VBox/Title/Icon.texture = editor_theme.get_icon("MultiEdit", "EditorIcons")
	$VBox/VarsListSection/Title/Icon.texture = editor_theme.get_icon("MultiLine", "EditorIcons")
	$VBox/VarsListSection/Header/Spacer.icon = editor_theme.get_icon("Remove", "EditorIcons")
	auto_name_button.icon = editor_theme.get_icon("FileList", "EditorIcons") # MatchCase, FileList, ListSelect
	for style in ["disabled", "focus", "hover", "normal", "pressed"]:
		auto_name_button.add_stylebox_override(style, editor_theme.get_stylebox(style, "Button"))
	
	auto_name_popup.connect("index_pressed", self, "_on_auto_name_popup_index_pressed")
	auto_name_regex.compile("{.*?}")
	value_edit.editor_interface = editor_interface
	
	_update_name_text()
	update_vars_list()
	ready = true

func update_vars_list() -> void:
	var empty: = object.text_vars.empty()
	
	no_vars_label.visible = empty
	vars_list.visible = not empty
	
	if empty:
		for item in vars_list.get_children():
			item.queue_free()
	else:
		var items: = {}
		
		for item in vars_list.get_children():
			if object.text_vars.has(item.var_name):
				items[item.var_name] = item
			else:
				item.queue_free()
		
		for var_name in object.text_vars:
			if not items.has(var_name):
				var value = object.text_vars[var_name]
				
				var item: = var_item_scene.instance()
				item.var_name = var_name
				item.editor_interface = editor_interface
				item.value = value
				item.connect("value_changed", self, "_on_VarItem_value_changed", [item])
				item.connect("rename", self, "_on_VarItem_rename", [item])
				item.connect("remove", self, "_on_VarItem_remove", [item])
				vars_list.add_child(item)
		
		var var_names: Array = object.text_vars.keys()
		var_names.sort()
		for i in var_names.size():
			var var_name: String = var_names[i]
			var item: = items.get(var_name) as Control
			if item:
				vars_list.move_child(item, i)

# Private #

func _update_name_text() -> void:
	var valid: = true
	var tooltip: String
	
	if name_edit.text.empty():
		valid = false
		tooltip = "Variable name can't be empty"
	elif name_edit.text in object.text_vars:
		valid = false
		tooltip = "A variable named \"" + name_edit.text + "\" already exists"
	
	add_button.disabled = not valid
	add_button.hint_tooltip = tooltip

func _update_auto_names() -> void:
	if auto_name_regex.is_valid():
		auto_names.clear()
		
		var matches: = auto_name_regex.search_all(object.source_text)
		for regex_match in matches:
			var var_name: String = regex_match.get_string()
			var_name = var_name.substr(1, var_name.length() - 2)
			
			if not var_name in object.text_vars:
				auto_names.append(var_name)
		
		auto_name_button.disabled = auto_names.empty()
		
		var source_text_name: = "source_text"
		if editor_interface.get_editor_settings().get_setting("interface/inspector/capitalize_properties"):
			source_text_name.capitalize()
		
		if not auto_names.empty():
			auto_name_button.hint_tooltip = "Set variable name from variables found in " + source_text_name
		elif matches.empty():
			auto_name_button.hint_tooltip = "No variable names found in " + source_text_name
		else:
			auto_name_button.hint_tooltip = "No variable names found in " + source_text_name + " that have not already been added"

# Connections #

func _on_VarItem_value_changed(item: Control) -> void:
	emit_signal("set_var", item.var_name, item.value)

func _on_VarItem_rename(new_name: String, item: Control) -> void:
	emit_signal("rename_var", item.var_name, new_name)

func _on_VarItem_remove(item: Control) -> void:
	emit_signal("remove_var", item.var_name)

func _on_NameEdit_text_changed(_new_text: String) -> void:
	_update_name_text()

func _on_OptionButton_item_selected(index: int) -> void:
	value_edit.type = index

func _on_AddButton_pressed() -> void:
	emit_signal("set_var", name_edit.text, value_edit.value)
	
	name_edit.text = ""
	value_edit.type = option_button.selected
	update_vars_list()
	_update_name_text()

func _on_AutoNameButton_about_to_show() -> void:
	_update_auto_names()
	
	auto_name_popup.clear()
	for var_name in auto_names:
		auto_name_popup.add_item(var_name)

func _on_auto_name_popup_index_pressed(index: int) -> void:
	name_edit.text = auto_name_popup.get_item_text(index)
	_update_name_text()

func _on_AutoNameRefreshTimer_timeout() -> void:
	if auto_name_popup and not auto_name_popup.visible:
		_update_auto_names()
