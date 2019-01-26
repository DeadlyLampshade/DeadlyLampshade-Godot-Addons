tool
extends EditorPlugin

const TAG_HINT = "editor_plugins/tag_hint"

const InspectorPlugin = preload("EditorInspectorPlugin/TagInspector.gd")
var inspector

func _enter_tree():
	inspector = InspectorPlugin.new()
	inspector.editor_settings = get_editor_interface().get_editor_settings()
	
	if !ProjectSettings.has_setting(TAG_HINT):
		ProjectSettings.set_setting(TAG_HINT, 23)
		ProjectSettings.add_property_info({"name": TAG_HINT, "type": TYPE_INT})
		ProjectSettings.set_initial_value(TAG_HINT, 23)
	
	add_inspector_plugin(inspector)
	pass

func _exit_tree():
	remove_inspector_plugin(inspector)
	pass
