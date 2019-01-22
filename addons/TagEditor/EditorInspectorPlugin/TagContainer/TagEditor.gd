tool
extends VBoxContainer

const BasicTag = preload("BasicTag.tscn")
var property : String = ""
var object : Object

var color = Color(0.5,0,0.25)

onready var label : Label = $HBoxContainer/Label
onready var line_edit : LineEdit = $HBoxContainer/LineEdit
onready var container : Container = $ScrollContainer/Control
onready var panel_container : PanelContainer = $ScrollContainer
onready var hide_button : Button = $HBoxContainer/HideButton

func _ready():
	pass # Replace with function body.

func _initialize(_property, _node, _color, _capitalize_property):
	property = _property
	label.text = _property.capitalize() if _capitalize_property else _property
	object = _node
	change_tag_visibility(false)
	color = _color if _color is Color else get_color("base_color", "Editor").linear_interpolate(get_color("accent_color", "Editor"), 0.33)
	var parent = container.get_parent() as Container
	parent.add_stylebox_override("panel", get_stylebox("Background", "EditorStyles"))

func add_item_save(value):
	if value == "": return
	add_item(value)
	panel_container.show()
	call_deferred("save_property")

func add_item(value):
	line_edit.text = ""
	var new_tag = BasicTag.instance()
	container.add_child(new_tag)
	new_tag.self_modulate = color
	new_tag.call_deferred("_set_label", value)
	new_tag.connect("tag_deleted", self, "delete_tag")

func delete_tag(node):
	node.queue_free()
	save_property()

func save_property():
	print("Set %s" % property)
	object.set(property, _save_data())

func _save_data():
	var array = PoolStringArray()
	for child in container.get_children():
		if !child.is_queued_for_deletion(): array.append(child.label.text)
	return array

func _load_data(data):
	for child in data:
		add_item(child)

func change_tag_visibility(_visible):
	panel_container.visible = _visible
	hide_button.text = "Hide" if _visible else "Show"

func hide_button_toggled():
	change_tag_visibility(!panel_container.visible)
	pass # Replace with function body.
