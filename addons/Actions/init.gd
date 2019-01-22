tool
extends EditorPlugin

const ActionInspector = preload("EditorInspectorPlugin/ActionInspector.gd")
var inspector

func _enter_tree():
	inspector = ActionInspector.new()
	inspector.editor_settings = get_editor_interface().get_editor_settings()
	add_inspector_plugin(inspector)

func _exit_tree():
	remove_inspector_plugin(inspector)