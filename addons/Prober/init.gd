tool
extends EditorPlugin

const PROPERTY_BAKE_ON_CREATE = "editor_plugins/deadlylampshade/prober/bake_on_create"
const PROPERTY_INITIAL_SUBDIV = "editor_plugins/deadlylampshade/prober/initial_subdiv"
const PROPERTY_EXTENT_GROWTH = "editor_plugins/deadlylampshade/prober/extent_growth"

const ProberButton = preload("ProberButton.tscn")
const OffsetCreator = preload("OffsetCreator.tscn")

var offset_creator

var button : MenuButton
var current_selection = []

func _enter_tree():
	var editor_control = get_editor_interface().get_base_control()
	button = ProberButton.instance()
	offset_creator = OffsetCreator.instance()
	editor_control.add_child(offset_creator)
	button.flat = true
	button.hide()

	if !ProjectSettings.has_setting(PROPERTY_BAKE_ON_CREATE):
		ProjectSettings.set_setting(PROPERTY_BAKE_ON_CREATE, true)
	if !ProjectSettings.has_setting(PROPERTY_INITIAL_SUBDIV):
		ProjectSettings.set_setting(PROPERTY_INITIAL_SUBDIV, 1)
	if !ProjectSettings.has_setting(PROPERTY_EXTENT_GROWTH):
		ProjectSettings.set_setting(PROPERTY_EXTENT_GROWTH, Vector3(0.1,0.1,0.1))

	ProjectSettings.add_property_info({"name": PROPERTY_BAKE_ON_CREATE, "type": TYPE_BOOL})
	ProjectSettings.add_property_info({"name": PROPERTY_INITIAL_SUBDIV, "type": TYPE_INT, "hint": PROPERTY_HINT_ENUM, "hint_string": "64,128,256,512"})
	ProjectSettings.add_property_info({"name": PROPERTY_EXTENT_GROWTH, "type": TYPE_VECTOR3})

	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)
	button.icon = button.get_icon("GIProbe", "EditorIcons")
	get_editor_interface().get_selection().connect("selection_changed", self, "get_selection")
	button.get_popup().connect("id_pressed", self, "get_popup_pressed")
	pass

func get_popup_pressed(id):
	var doing_stuff = false
	var probe
	match(id):
		0: 
			probe = create_gi_probe()
			doing_stuff = true
		1: 
			probe = yield(create_gi_probe_with_offset(), "completed")
			doing_stuff = true
		2: 
			create_baked_lightmap()
		3:
			create_baked_lightmap_with_offset()
	if ProjectSettings.get_setting(PROPERTY_BAKE_ON_CREATE) \
		and doing_stuff \
		and probe != null:
		probe.subdiv = ProjectSettings.get_setting(PROPERTY_INITIAL_SUBDIV)
		probe.bake()

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
		if object is GeometryInstance and !array.has(object):
			if object.use_in_baked_light: array.append(object)
		for child in check_children_for_nodes(object):
			if !array.has(child): array.append(child)
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
	
	return baked_lightmap

func create_baked_lightmap_with_offset():
	var result : Dictionary = yield(offset_creator.start_popup(), "completed")
	if result.empty(): return null
	var lightmap = create_baked_lightmap()
	
	lightmap.bake_extents.x += result.x.offset
	match(result.x.pos):
		0: lightmap.translation.x -= result.x.offset
		2: lightmap.translation.x += result.x.offset
	
	lightmap.bake_extents.y += result.y.offset
	match(result.y.pos):
		0: lightmap.translation.y -= result.y.offset
		2: lightmap.translation.y += result.y.offset
	
	lightmap.bake_extents.z += result.z.offset
	match(result.z.pos):
		0: lightmap.translation.z -= result.z.offset
		2: lightmap.translation.z += result.z.offset
	return lightmap

func create_gi_probe_with_offset():
	var result : Dictionary = yield(offset_creator.start_popup(), "completed")
	if result.empty(): return null
	var probe = create_gi_probe()
	
	probe.extents.x += result.x.offset
	match(result.x.pos):
		0: probe.translation.x -= result.x.offset
		2: probe.translation.x += result.x.offset
	
	probe.extents.y += result.y.offset
	match(result.y.pos):
		0: probe.translation.y -= result.y.offset
		2: probe.translation.y += result.y.offset
	
	probe.extents.z += result.z.offset
	match(result.z.pos):
		0: probe.translation.z -= result.z.offset
		2: probe.translation.z += result.z.offset
	
	return probe

func create_gi_probe():
	var aabb = make_aabb()
	var gi_probe = GIProbe.new()
	var _owner = get_editor_interface().get_edited_scene_root()
	_owner.add_child(gi_probe)
	gi_probe.owner = _owner
	gi_probe.extents = (aabb.size/2.0) + ProjectSettings.get_setting(PROPERTY_EXTENT_GROWTH)
	gi_probe.translation = aabb.position + (aabb.size/2.0)
	return gi_probe

func _exit_tree():
	offset_creator.queue_free()
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, button)
	button.queue_free()
