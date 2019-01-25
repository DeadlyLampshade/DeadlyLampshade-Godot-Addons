tool
extends EditorPlugin

const ProberButton = preload("ProberButton.tscn")

var button : MenuButton
var current_selection = []

func _enter_tree():
	button = ProberButton.instance()
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
	button.get_popup().connect("id_pressed", self, "get_popup_pressed")
	pass

func get_popup_pressed(id):
	match(id):
		0: create_gi_probe()
		1: create_baked_lightmap()

func check_children_for_nodes(node):
	var array = []
	for child in node.get_children():
		if child is GeometryInstance:
			if child.use_in_baked_light: array.append(child)
		array += check_children_for_nodes(child)
	return array

func get_selection():
	var selection : EditorSelection = get_editor_interface().get_selection()
	var selected_objects = selection.get_selected_nodes()
	var array = []
	for object in selected_objects:
		if object is GeometryInstance:
			if object.use_in_baked_light: array.append(object)
		array += check_children_for_nodes(object)
	print(array)
	if !array.empty():
		button.show()
	else:
		button.hide()
	current_selection = array

func make_aabb():
	var aabb : AABB = AABB(Vector3(0,0,0), Vector3(0,0,0))
	for item in current_selection:
		if aabb.has_no_surface():
			aabb = item.get_transformed_aabb()
		else:
			aabb = aabb.merge(item.get_transformed_aabb())
	return aabb

func create_baked_lightmap():
	var aabb = make_aabb()
	var baked_lightmap = BakedLightmap.new()
	var _owner = get_editor_interface().get_edited_scene_root()
	_owner.add_child(baked_lightmap)
	baked_lightmap.owner = _owner
	baked_lightmap.bake_extents = (aabb.size/2.0) + ProjectSettings.get_setting("editor_plugins/prober/extent_growth")
	baked_lightmap.translation = aabb.position + (aabb.size/2.0)

func create_gi_probe():
	var aabb = make_aabb()
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
