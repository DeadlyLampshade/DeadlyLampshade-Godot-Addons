tool
extends VBoxContainer

const TARGETER = preload("NewTargeter.tscn")

var property : String
var object : Object

onready var label = $Top/Label
onready var main = $Main
onready var hide_button = $Top/Button

var targeters = []

func _initialize(_property, _object, _capitalize):
	property = _property
	object = _object
	call_deferred("_set_property_label", property.capitalize() if _capitalize else property)
	call_deferred("_load_data", object.get(property))

func _set_property_label(value):
	label.text = value

func toggle_targeting_display():
	change_targeting_visibility(!main.visible)

func change_targeting_visibility(value):
	main.visible = value
	hide_button.text = "Hide" if value else "Show"

func add_new_targeter_save():
	add_new_targeter("")
	save_property()

func save_property():
	print("Set %s" % property)
	object.set(property, _save_data())

func delete_targeter(object):
	targeters.erase(object)
	object.queue_free()
	save_property()

func add_new_targeter(value):
	var new_targeter = TARGETER.instance()
	main.add_child(new_targeter)
	targeters.append(new_targeter)
	new_targeter.call_deferred("_initialize", value)
	new_targeter.connect("property_changed", self, "save_property")
	new_targeter.connect("delete_targeter", self, "delete_targeter")
	pass

func _save_data():
	var array = PoolStringArray([])
	for child in targeters:
		array.append(child._save_data())
	return array

func _load_data(data):
	if data == null: return
	for child in data:
		add_new_targeter(child)