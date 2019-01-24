tool
extends EditorPlugin

var button
var current_selection = []

func _enter_tree():
	button = Button.new()
	button.text = "Create GI Probe"
	button.flat = true
	button.hide()
	
	if !ProjectSettings.has_setting("editor_plugins/prober/bake_on_create"):
		ProjectSettings.set_setting("editor_plugins/prober/bake_on_create", true)
	if !ProjectSettings.has_setting("editor_plugins/prober/initial_subdiv"):
		ProjectSettings.set_setting("editor_plugins/prober/initial_subdiv", 1)
	if !ProjectSettings.has_setting("editor_plugins/prober/extent_growth"):
		ProjectSettings.set_setting("editor_plugins/prober/extent_growth", Vector3(0.1,0.1,0.1))
	
	ProjectSettings.add_property_info({"name": "editor_plugins/prober/bake_on_create", "type": TYPE_BOOL})
	ProjectSettings.add_property_info({"name": "editor_plugins/prober/initial_subdiv", "type": TYPE_INT, "hint": PROPERTY_HINT_ENUM, "hint_string": "64,128,256,512"})
	ProjectSettings.add_property_info({"name": "editor_plugins/prober/extent_growth", "type": TYPE_VECTOR3})
	
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)
	button.icon = button.get_icon("GIProbe", "EditorIcons")
	get_editor_interface().get_selection().connect("selection_changed", self, "get_selection")
	button.connect("pressed", self, "create_gi_probe")
	pass

func get_selection():
	var selection : EditorSelection = get_editor_interface().get_selection()
	var selected_objects = selection.get_selected_nodes()
	var array = []
	for object in selected_objects:
		if object is GeometryInstance:
			if object.use_in_baked_light: array.append(object)
	print(array)
	if !array.empty():
		button.show()
	else:
		button.hide()
	current_selection = array

func create_gi_probe():
	var aabb = null
	for item in current_selection:
		if aabb == null:
			aabb = item.get_transformed_aabb()
		else:
			aabb = aabb.merge(item.get_transformed_aabb())
	var gi_probe = GIProbe.new()
	var _owner = get_editor_interface().get_edited_scene_root()
	_owner.add_child(gi_probe)
	gi_probe.owner = _owner
	gi_probe.extents = (aabb.size/2.0) + ProjectSettings.get_setting("editor_plugins/prober/extent_growth")
	gi_probe.translation = aabb.position + (aabb.size/2.0)
	if ProjectSettings.get_setting("editor_plugins/prober/bake_on_create"):
		gi_probe.subdiv= ProjectSettings.get_setting("editor_plugins/prober/initial_subdiv")
		gi_probe.bake()

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, button)
	button.queue_free()
