extends Node

var items : Dictionary = {}
var party: Array = [preload("res://Battle/Allies/debug_character.tres"),preload("res://Battle/Allies/debug_character2.tres"),]
var flags: Dictionary = {}
var rooms: Dictionary = {}

func _ready() -> void:
	load_resources_to_dict("res://Items/", items)
	Util.set_keys_to_names(items)
	for i in party:
		i.init()

func load_resources_to_dict(path: String, dict: Dictionary) -> void:
	var dir: DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directorey: " + file_name)
			else:
				dict[file_name.replace(".tres", "")] = load(path + file_name)
			file_name = dir.get_next()
