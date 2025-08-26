class_name InventoryMenu extends Menu

var inventory: Inventory = null :
	set(value):
		if inventory == value:
			return
			
		inventory = value
		
		for button: ItemButton in get_buttons():
			button.item = inventory.get_item_by_position(button.get_index())

func _ready() -> void:
	# Super indicated that we're calling this function from the class we're extending
	super()
	hide()

#func _on_inventory_updated() -> void:
	#pass
