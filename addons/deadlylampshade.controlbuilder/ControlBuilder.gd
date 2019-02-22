extends Reference
class_name ControlBuilder

var tree = null
var context = []
var last_created_node 

func finish():
	# Returns the current tree.
	# Clears the state of the builder so it can be used again for something else.
	
	var previous_tree = tree
	tree = null
	context = []
	return previous_tree

func insert_object(object):
	# Places the object as either
	# - The child of the current context
	# - The child of the tree
	# - The new tree object.
	if !context.empty():
		context.back().add_child(object)
	elif tree is Node:
		tree.add_child(object)
	elif tree == null:
		tree = object
	last_created_node = object

func start_context(object=last_created_node):
	if object is Node:
		context.append(object)
	return object

func end_context():
	if !context.empty():
		context.pop_back()

# BUTTONS
#---------

func add_button(title = "NewButton", icon=null, h_flags=1, v_flags=1, stretching=1.0):
	var object = Button.new()
	object.text = title
	object.icon = icon
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_check_box(title = "CheckBox", icon = null, h_flags=1, v_flags=1, stretching =1.0):
	var object = CheckBox.new()
	object.text = title
	object.icon = icon
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_check_button(title = "CheckButton", icon =null, h_flags=1, v_flags=1, stretching=1.0):
	var object = CheckButton.new()
	object.text = title
	object.icon = icon
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

# COLOR
#-------

func add_color_picker_button(color = Color.black, h_flags = 1, v_flags = 1, stretching=1.0):
	var object = ColorPickerButton.new()
	object.color = color
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_color_picker(color = Color.black, h_flags=1, v_flags=1, stretching=1.0):
	var object = ColorPicker.new()
	object.color = color
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

# TEXT EDITING
#--------------

func add_line_edit(h_flags=1, v_flags=1, stretching=1.0):
	var object = LineEdit.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_text_edit(h_flags=1, v_flags=1, stretching=1.0):
	var object = TextEdit.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

# RANGE
#-------
func add_spin_box(_min=0, _max=100, h_flags=1, v_flags=1, stretching=1.0):
	var object = SpinBox.new()
	object.min_value = _min
	object.max_value = _max
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_hscroll(_min=0, _max=100, h_flags=1, v_flags=1, stretching=1.0):
	var object = HScrollBar.new()
	object.min_value = _min
	object.max_value = _max
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_vscroll(_min=0, _max=100, h_flags=1, v_flags=1, stretching=1.0):
	var object = VScrollBar.new()
	object.min_value = _min
	object.max_value = _max
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_hslider(_min=0, _max=100, h_flags=1, v_flags=1, stretching=1.0):
	var object = HSlider.new()
	object.min_value = _min
	object.max_value = _max
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_vslider(_min=0, _max=100, h_flags=1, v_flags=1, stretching=1.0):
	var object = VSlider.new()
	object.min_value = _min
	object.max_value = _max
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_progress_bar(_min=0, _max=100, h_flags=1, v_flags=1, stretching=1.0):
	var object = ProgressBar.new()
	object.min_value = _min
	object.max_value = _max
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

# GENERIC OR ABSTRACT
#---------------------

func add_label(text = "Text", h_flags=1, v_flags=1, stretching=1.0):
	var object = Label.new()
	object.text = text
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_blank_control(h_flags=1, v_flags=1, stretching=1.0):
	var object = Control.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_vseperator(h_flags=1, v_flags=1, stretching=1.0):
	var object = VSeparator.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_hseperator(h_flags=1, v_flags=1, stretching=1.0):
	var object = HSeparator.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_custom_control(object, h_flags=1, v_flags=1, stretching=1.0):
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

# INSTANT CONTAINER
#-------------------

func add_hbox(h_flags=1, v_flags=1, stretching=1.0):
	var object = HBoxContainer.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_vbox(h_flags=1, v_flags=1, stretching=1.0):
	var object = VBoxContainer.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_hsplit(h_flags=1, v_flags=1, stretching=1.0):
	var object = HSplitContainer.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_vsplit(h_flags=1, v_flags=1, stretching=1.0):
	var object = VSplitContainer.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_panelbox(h_flags=1, v_flags=1, stretching = 1.0):
	var object = PanelContainer.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_center_container(h_flags = 1, v_flags = 1, stretching = 1.0):
	var object = CenterContainer.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_scroll_container(vertical = true, horizontal = false, h_flags=1, v_flags=1, stretching =1.0):
	var object = ScrollContainer.new()
	object.scroll_vertical_enabled = vertical
	object.scroll_horizontal_enabled = horizontal
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_grid_container(columns=2, h_flags=1, v_flags=1, stretching=1.0):
	var object = GridContainer.new()
	object.columns = columns
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

func add_tab_container(h_flags=1, v_flags=1, stretching=1.0):
	var object = TabContainer.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

# HELPER FUNCTIONS
#------------------
static func set_size_flags(object, h_flags= 1, v_flags= 1, stretching= 1):
	object.size_flags_horizontal = h_flags
	object.size_flags_vertical = v_flags
	object.size_flags_stretch_ratio = stretching