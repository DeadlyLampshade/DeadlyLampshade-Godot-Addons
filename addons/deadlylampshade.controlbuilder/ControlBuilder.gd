extends Reference
class_name ControlBuilder

var tree = null
var context = null

func finish():
	# Returns the current tree.
	# Clears the state of the builder so it can be used again for something else.
	
	var previous_tree = tree
	tree = null
	context = null
	return previous_tree

func insert_object(object):
	# Places the object as either
	# - The child of the current context
	# - The child of the tree
	# - The new tree object.
	if context is Node:
		context.add_child(object)
	elif context == null and tree is Node:
		tree.add_child(object)
	elif tree == null:
		tree = object

func make_parent_context():
	# Makes the parent of the context, the new context.
	# If the parent is not a child of the tree, it makes the context null instead.
	
	var parent = context.get_parent()
	if tree.is_a_parent_of(parent):
		context = parent
	else:
		context = null
	return context

func make_context(object):
	# Objects are added to the context node before the tree.
	
	if object is Node:
		context = object
	else:
		context = null
	return object

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

func add_color_picker_button(h_flags = 1, v_flags = 1, stretching=1.0):
	var object = ColorPickerButton.new()
	set_size_flags(object, h_flags, v_flags, stretching)
	insert_object(object)
	return object

# TEXT EDITING
#--------------

func add_line_edit(h_flags=1, v_flags=1, stretching=1.0):
	var line_edit = LineEdit.new()
	set_size_flags(line_edit, h_flags, v_flags, stretching)
	insert_object(line_edit)
	return line_edit

# GENERIC OR ABSTRACT
#---------------------

func add_label(text = "Text", h_flags=1, v_flags=1, stretching=1.0):
	var label = Label.new()
	label.text = text
	set_size_flags(label, h_flags, v_flags, stretching)
	insert_object(label)
	return label

func add_blank_control(h_flags=1, v_flags=1, stretching=1.0):
	var control = Control.new()
	set_size_flags(control, h_flags, v_flags, stretching)
	insert_object(control)
	return control

func add_custom_control(control, h_flags=1, v_flags=1, stretching=1.0):
	set_size_flags(control, h_flags, v_flags, stretching)
	insert_object(control)
	return control

# INSTANT CONTAINER
#-------------------

func add_hbox_container(h_flags=1, v_flags=1, stretching=1.0):
	var hbox = HBoxContainer.new()
	set_size_flags(hbox, h_flags, v_flags, stretching)
	insert_object(hbox)
	return hbox

func add_vbox_container(h_flags=1, v_flags=1, stretching=1.0):
	var vbox = VBoxContainer.new()
	set_size_flags(vbox, h_flags, v_flags, stretching)
	insert_object(vbox)
	return vbox

func add_panel_container(h_flags=1, v_flags=1, stretching = 1.0):
	var box = PanelContainer.new()
	set_size_flags(box, h_flags, v_flags, stretching)
	insert_object(box)
	return box

func add_center_container(h_flags = 1, v_flags = 1, stretching = 1.0):
	var center = CenterContainer.new()
	set_size_flags(center, h_flags, v_flags, stretching)
	insert_object(center)
	return center

func add_scroll_container(vertical = true, horizontal = false, h_flags=1, v_flags=1, stretching =1.0):
	var scroll = ScrollContainer.new()
	scroll.scroll_vertical_enabled = vertical
	scroll.scroll_horizontal_enabled = horizontal
	set_size_flags(scroll, h_flags, v_flags, stretching)
	insert_object(scroll)
	return scroll

func add_grid_container(columns=2, h_flags=1, v_flags=1, stretching=1.0):
	var gbox = GridContainer.new()
	gbox.columns = columns
	set_size_flags(gbox, h_flags, v_flags, stretching)
	insert_object(gbox)
	return gbox

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