tool
extends PanelContainer

signal property_changed
signal delete_targeter(object)

onready var value = $HBoxContainer/LineEdit

func _initialize(data):
	value.text = data
	add_stylebox_override("panel", get_stylebox("Background", "EditorStyles"))

func _save_data():
	return value.text

func targeter_changed(new_text):
	emit_signal("property_changed")

func delete_targeter():
	emit_signal("delete_targeter", self)
