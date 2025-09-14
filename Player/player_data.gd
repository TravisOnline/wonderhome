extends Node

var items : Dictionary = {}
var party: Array = [preload("res://Battle/Allies/debug_character.tres"),preload("res://Battle/Allies/debug_character2.tres"),]
var flags: Dictionary = {}
var rooms: Dictionary = {}

var playeritems: Array[Item]
var playerinventory: Inventory = null

# This is linked to inventory_menu in order to update item quantities in the menu when used
signal _inventory_altered()

func _ready() -> void:
	load_resources_to_dict("res://Items/", items)
	Util.set_keys_to_names(items)
	for i in party:
		i.init()
	debug_add_items()
	initialise_inventory()

func debug_add_items() -> void:
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
	# Using a for loop here to go through all items in the inventory to delete them
	# really sucks. TODO: find more efficient way to achieve this
	for i in playeritems.size():
		if playeritems[i].name == this_item.name:
			playeritems.remove_at(i)
			break
	if playerinventory.get_quantity(this_item) <= 0:
		# Seems silly, but this code prevents items from showing up and -being usable- with 0
		# Of the item in the inventory
		playerinventory.remove_item(this_item)
	emit_signal("_inventory_altered")
