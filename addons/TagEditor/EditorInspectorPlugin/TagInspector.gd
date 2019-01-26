tool
extends EditorInspectorPlugin

const TAG_HINT = "editor_plugins/deadlylampshade/tag_editor/tag_hint"

const TagEditor = preload("TagContainer/TagEditor.tscn")

var editor_settings : EditorSettings

func can_handle(object):
	return true

func parse_property(object, type, path, hint, hint_text, usage):
	var is_editor = usage & PROPERTY_USAGE_EDITOR
	if is_editor == 0: return false
	var is_array = type == TYPE_ARRAY or type == TYPE_STRING_ARRAY
	if hint == ProjectSettings.get_setting(TAG_HINT) and is_array: return do_tag_property(object, type, path, hint, hint_text, usage)
	return false

func do_tag_property(object, type, path, hint, hint_text : String, usage):
	var capitalize_property = editor_settings.get_setting("interface/inspector/capitalize_properties")
	var value = object.get(path)
	var editor = TagEditor.instance()
	add_custom_control(editor)
	var _color = Color(hint_text) if hint_text.is_valid_html_color() else null
	editor.call_deferred("_initialize", path, object, _color, capitalize_property)
	if value is PoolStringArray:
		editor.call_deferred("_load_data", value)
	else:
		editor.call_deferred("_load_data", PoolStringArray([]))
	return true