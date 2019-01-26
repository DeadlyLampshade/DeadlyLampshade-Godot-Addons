tool
extends Container
class_name TagContainer

export(int) var hseperation = 5
export(int) var vseperation = 5

func _ready():
	pass # Replace with function body.

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		_perform_sort()

func _perform_sort():
	var rect = rect_size
	var children = get_children()
	var line_size = Vector2(0,0)
	var offset = 0
	var line = []
	while !children.empty():
		var child = children.pop_front()
		if not child is Control or not child.visible: continue
		var min_size = child.get_combined_minimum_size()
		line_size.x += min_size.x
		if line_size.x > rect.x:
			_sort_line(line, line_size.y, offset)
			offset += line_size.y + vseperation
			line_size = Vector2(min_size.x,0)
			line = []
		line_size.x += hseperation
		line_size.y = max(min_size.y,line_size.y)
		line.append(child)
	_sort_line(line, line_size.y, offset)
	var min_y_size = line_size.y + offset
	rect_size.y = min_y_size
	rect_min_size = Vector2(0,min_y_size)

func _sort_line(line, size, position):
	var offset_x = 0
	for child in line:
		var new_offset_x = child.get_combined_minimum_size().x
		fit_child_in_rect(child, Rect2(Vector2(offset_x, position), Vector2(new_offset_x, size)))
		offset_x += new_offset_x + hseperation