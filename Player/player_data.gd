extends Node

var items : Dictionary = {}
var party: Array = [preload("res://Battle/Allies/debug_character.tres"),preload("res://Battle/Allies/debug_character2.tres"),]
var flags: Dictionary = {}
var rooms: Dictionary = {}

var playeritems: Array[Item]
var playerinventory: Inventory = null

func _ready() -> void:
	load_resources_to_dict("res://Items/", items)
	Util.set_keys_to_names(items)
	for i in party:
		i.init()
	debug_add_items()
	initialise_inventory()

func debug_add_items() -> void:
	playeritems.append(items["refreshing_herb"])
	playeritems.append(items["refreshing_herb"])
	playeritems.append(items["refreshing_herb"])

func initialise_inventory() -> void:
	if playeritems:
		playerinventory = Inventory.new()
		for i: Item in playeritems:
			playerinventory.add_item(i)

func load_resources_to_dict(path: String, dict: Dictionary) -> void:
	var dir: DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				dict[file_name.replace(".tres", "")] = load(path + file_name)
			file_name = dir.get_next()

func remove_item_from_inventory(this_item : Item) -> void:
	playerinventory.remove_item(this_item)
