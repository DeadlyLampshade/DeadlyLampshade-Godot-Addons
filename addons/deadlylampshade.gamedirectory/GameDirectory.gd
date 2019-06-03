extends Reference
class_name GameDirectory

func check_item(item : String, file_types):
	if file_types != null:
		for type in file_types:
			if item.matchn(type):
				return true
	else:
		return true
	return false

func examine_folders(path, recursive = false):
	# Examine all folders at a path,
	var directory = Directory.new()
	var list = []
	var inner_directory = []
	if directory.open(path) == OK:
		var err = directory.list_dir_begin(true, false)
		var currentItem = directory.get_next()
		while !currentItem.empty():
			if directory.current_is_dir():
				inner_directory.append(currentItem)
				list.append("%s/%s" % [path, currentItem])
			currentItem = directory.get_next()
		
		if recursive:
			for dir in inner_directory:
				list += examine_folders("%s/%s" % [path,dir], true)
	return list

func examine_contents(path, recursive = true, file_type_string = ""):
	# Examine all the contents in the folder,
	var file_types = null
	if !file_type_string.empty():
		file_types = file_type_string.rsplit(",") as Array
	
	var directory = Directory.new()
	var list = []
	
	if directory.open(path) == OK:
		var inner_directory = []
		var err = directory.list_dir_begin(true, false)
		var currentItem = directory.get_next()
		while !currentItem.empty():
			if directory.current_is_dir() and recursive:
				inner_directory.append(currentItem)
			elif !directory.current_is_dir():
				if check_item(currentItem, file_types):
					var item = "%s/%s" % [path, currentItem]
					list.append(item)
			currentItem = directory.get_next()
		
		if recursive:
			for dir in inner_directory:
				list += examine_contents("%s/%s" % [path,dir])
	
	return list