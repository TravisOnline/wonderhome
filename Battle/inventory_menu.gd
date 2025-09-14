class_name InventoryMenu extends Menu

# This script instantiates the player inventory menu when it's selected.
# It will create and assign item buttons 

var inventory: Inventory = null :
	set(value):
		if inventory == value:
			return
			
		inventory = value
		
		for button: ItemButton in get_buttons():
			button.item = inventory.get_item_by_position(button.get_index())
			

func _ready() -> void:
	# Super indicates that we're calling this function from the class we're extending
	super()
	PlayerData._inventory_altered.connect(_on_inventory_updated)
	hide()

func _on_inventory_updated() -> void:
	for button: ItemButton in get_buttons():
		button.item = inventory.get_item_by_position(button.get_index())
