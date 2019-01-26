tool
extends PanelContainer

signal tag_deleted(object)

onready var label : Label = $HBoxContainer/Label

func _set_label(value):
	label.text = value

func delete_tag():
	emit_signal("tag_deleted", self)