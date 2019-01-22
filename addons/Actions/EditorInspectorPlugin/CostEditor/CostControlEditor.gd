tool
extends VBoxContainer

const NewCost = preload("NewCost.tscn")
var object = null
var property = ""

var costs = []
onready var label =  $HBoxContainer/Label
onready var container = $VBoxContainer
onready var hide_button = $HBoxContainer/Button

func add_item():
	var new_cost = NewCost.instance()
	container.add_child(new_cost)
	new_cost._initialize()
	costs.append(new_cost)
	new_cost.connect("delete_cost", self, "delete_cost")
	new_cost.connect("cost_changed", self, "cost_changed")
	save_changes()

func delete_cost(node):
	node.queue_free()
	costs.erase(node)
	save_changes()

func _save_changes():
	var array = []
	for child in costs:
		array.append(child._save())
	return {
		"visible": container.visible,
		"costs": array
	}

func cost_changed():
	save_changes()

func save_changes():
	print("Set %s" % property)
	object.set(property, _save_changes())

func _load_data(_name, data, capitalize):
	label.text = _name.capitalize() if capitalize else _name
	change_visibility(data.get("visible", true))
	for cost in data.get("costs", []):
		var new_cost = NewCost.instance()
		container.add_child(new_cost)
		costs.append(new_cost)
		new_cost._load(cost)
		new_cost._initialize()
		new_cost.connect("delete_cost", self, "delete_cost")
		new_cost.connect("cost_changed", self, "cost_changed")

func change_visibility(visibility = !container.visible):
	container.visible = visibility
	hide_button.text = "Hide" if container.visible else "Show"

func toggle_visibility(visibility = !container.visible):
	change_visibility(visibility)
	save_changes()