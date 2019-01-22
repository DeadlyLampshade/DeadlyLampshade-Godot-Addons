tool
extends EditorInspectorPlugin

const CostControl = preload("CostEditor/CostControl.tscn")
const TargetControl = preload("TargetingEditor/TargetingEditor.tscn")

var editor_settings : EditorSettings

func can_handle(object):
	return true

func parse_property(object, type, path, hint, hint_text, usage):
	var is_editor = usage & PROPERTY_USAGE_EDITOR
	if is_editor == 0: return false
	var is_array = type == TYPE_ARRAY or type == TYPE_STRING_ARRAY
	if hint == 24: return do_cost_property(object, type, path, hint, hint_text, usage)
	if hint == 25: return do_target_property(object, type, path, hint, hint_text, usage)
	return false

func do_cost_property(object, type, path, hint, hint_text, usage):
	var capitalize_property = editor_settings.get_setting("interface/inspector/capitalize_properties")
	var value = object.get(path)
	var controller = CostControl.instance()
	add_custom_control(controller)
	controller.object = object
	controller.property = path
	if value is Dictionary:
		controller.call_deferred("_load_data", path, value, capitalize_property)
	else:
		controller.call_deferred("_load_data", path, {"costs": []})
	return true

func do_target_property(object, type, path, hint, hint_text, usage):
	var capitalize_property = editor_settings.get_setting("interface/inspector/capitalize_properties")
	var editor = TargetControl.instance()
	add_custom_control(editor)
	editor._initialize(path, object, capitalize_property)
	return true