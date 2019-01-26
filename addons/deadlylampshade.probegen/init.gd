tool
extends EditorPlugin

const PROPERTY_DIRECTORY = "deadlylampshade/prober"

const PROPERTY_BAKE_GI = "gi_probes/bake_gi"
const PROPERTY_BAKE_LIGHTMAPS = "baked_lightmaps/bake_lightmaps"
const PROPERTY_INITIAL_SUBDIV = "gi_probes/subdivisions"
const PROPERTY_EXTENT_GROWTH = "extent_growth"
const PROPERTY_LIGHTMAP_QUALITY = "baked_lightmaps/quality"
const PROPERTY_LIGHTMAP_MODE = "baked_lightmaps/mode"

const ProberButton = preload("ProberButton.tscn")
const OffsetCreator = preload("OffsetCreator.tscn")

var offset_creator

var button : MenuButton
var current_selection = []

func _enter_tree():
	var editor_control = get_editor_interface().get_base_control()
	var editor_selector = get_editor_interface().get_selection()
	button = ProberButton.instance()
	offset_creator = OffsetCreator.instance()
	editor_control.add_child(offset_creator)
	button.flat = true
	button.hide()
	
	editor_property(PROPERTY_EXTENT_GROWTH, TYPE_VECTOR3, Vector3(0.1,0.1,0.1))
	editor_property(PROPERTY_BAKE_GI, TYPE_BOOL, false)
	editor_property(PROPERTY_INITIAL_SUBDIV, TYPE_INT, 1, PROPERTY_HINT_ENUM, "64,128,256,512")
	editor_property(PROPERTY_BAKE_LIGHTMAPS, TYPE_BOOL, false)
	editor_property(PROPERTY_LIGHTMAP_QUALITY, TYPE_INT, 1, PROPERTY_HINT_ENUM, "Low,Medium,High")
	editor_property(PROPERTY_LIGHTMAP_MODE, TYPE_INT, 0, PROPERTY_HINT_ENUM, "ConeTrace,RayTrace")
	
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)
	button.icon = button.get_icon("GIProbe", "EditorIcons")
	editor_selector.connect("selection_changed", self, "get_selection")
	button.get_popup().connect("id_pressed", self, "get_popup_pressed")
	pass

func editor_property(_name, _type, _default, _hint = 0, _hint_string = ""):
	_name = "%s/%s" % [PROPERTY_DIRECTORY, _name]
	if !ProjectSettings.has_setting(_name):
		ProjectSettings.set_setting(_name, _default)
	ProjectSettings.set_initial_value(_name, _default)
	ProjectSettings.add_property_info({"name": _name, "type": _type, "hint":_hint, "hint_string": _hint_string})

func get_popup_pressed(id):
	var doing_stuff = false
	var probe
	match(id):
		0: 
			probe = create_gi_probe()
		1: 
			probe = yield(create_gi_probe_with_offset(), "completed")
		2: 
			probe = create_baked_lightmap()
		3:
			probe = yield(create_baked_lightmap_with_offset(), "completed")
	if probe != null:
		if probe is GIProbe: perform_gi_bake(probe)
		if probe is BakedLightmap: perform_lightmap_bake(probe)

func perform_gi_bake(probe):
	if ProjectSettings.get_setting(PROPERTY_BAKE_GI):
		var err = probe.bake()

func perform_lightmap_bake(probe : BakedLightmap):
	if ProjectSettings.get_setting(PROPERTY_BAKE_LIGHTMAPS):
		var err = probe.bake()

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
	baked_lightmap.bake_quality = ProjectSettings.get_setting(PROPERTY_LIGHTMAP_QUALITY)
	baked_lightmap.bake_mode = ProjectSettings.get_setting(PROPERTY_LIGHTMAP_MODE)
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
	gi_probe.subdiv = ProjectSettings.get_setting(PROPERTY_INITIAL_SUBDIV)
	return gi_probe

func _exit_tree():
	offset_creator.queue_free()
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, button)
	button.queue_free()
