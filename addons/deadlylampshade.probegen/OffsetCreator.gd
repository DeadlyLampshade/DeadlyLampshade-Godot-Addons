tool
extends WindowDialog

var success = false

onready var x_value = $MainContainer/VectorContainer/XContainer/Offset/LineEdit
onready var x_pos = $MainContainer/VectorContainer/XContainer/Placement/OptionButton
onready var y_value = $MainContainer/VectorContainer/YContainer/Offset/LineEdit
onready var y_pos = $MainContainer/VectorContainer/YContainer/Placement/OptionButton
onready var z_value = $MainContainer/VectorContainer/ZContainer/Offset/LineEdit
onready var z_pos = $MainContainer/VectorContainer/ZContainer/Placement/OptionButton

func start_popup():
	success = false
	popup_centered_minsize()
	yield(self, "popup_hide")
	var results
	if success:
		results = results()
	else:
		results = {}
	return results

func pressed_finish():
	success = true
	hide()

func results():
	var dict = {
		"x":
			{
				"offset": float(x_value.text),
				"pos": x_pos.selected,
			},
		"y":
			{
				"offset": float(y_value.text),
				"pos": y_pos.selected,
			},
		"z":
			{
				"offset": float(z_value.text),
				"pos": z_pos.selected,
			}
	}
	return dict