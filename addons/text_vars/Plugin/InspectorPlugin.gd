extends EditorInspectorPlugin

const PROPERTY: = "text_vars"

var text_vars_editor_property: = preload("../PropertyEditor/TextVarsEditorProperty.gd")
var editor_interface: EditorInterface

func can_handle(object: Object) -> bool:
	return object.has_method("__is_text_vars__")

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if path == PROPERTY:
		var editor_property: = text_vars_editor_property.new()
		editor_property.editor_interface = editor_interface
		add_property_editor(PROPERTY, editor_property)
		return true
	else:
		return false
