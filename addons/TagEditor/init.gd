tool
extends EditorPlugin

const InspectorPlugin = preload("EditorInspectorPlugin/TagInspector.gd")
var inspector

func _enter_tree():
	inspector = InspectorPlugin.new()
	inspector.editor_settings = get_editor_interface().get_editor_settings()
	add_inspector_plugin(inspector)
	pass

func _exit_tree():
	remove_inspector_plugin(inspector)
	pass
