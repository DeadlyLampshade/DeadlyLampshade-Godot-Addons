tool
extends PanelContainer

signal cost_changed()
signal delete_cost(object)

onready var cost_types = $HBoxContainer/VBoxContainer/TypeValue
onready var amount = $HBoxContainer/VBoxContainer/AmountValue

func _initialize():
	add_stylebox_override("panel", get_stylebox("Background", "EditorStyles"))

func _save():
	return {
		"cost_type": cost_types.selected,
		"amount": as_float_or_int(amount.text)
	}

static func as_float_or_int(string : String):
	if string.is_valid_float():
		return string.to_float()
	elif string.is_valid_integer():
		return string.to_int()
	else:
		return string

func _load(data):
	set_block_signals(true)
	cost_types.select(data.get("cost_type", 0))
	amount.text = str(data.get("amount", 0))
	set_block_signals(false)

func delete_cost():
	emit_signal("delete_cost", self)

func id_changed(ID):
	emit_signal("cost_changed")

func value_changed(value):
	amount.text = str(as_float_or_int(value))
	emit_signal("cost_changed")
