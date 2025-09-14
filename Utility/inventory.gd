class_name Inventory extends Resource

signal updated()

var items: Array = []
var max_size: int = 10

func get_items() -> Array:
	return items
	
func get_size() -> int:
	return items.size()
	
func get_item_by_name(item_name: String) -> Item:
	for item: Item in items:
		if item.name == item_name:
			return item
	return null
	
func get_item_by_position(pos: int) -> Item:
	if pos < items.size():
		return items[pos]
	return null

func add_item_by_name(item_name: String, quantity: int = 1) -> bool:
	var item: Item = PlayerData.items.get(item_name)
	
	if not item:
		return false
		
	if item.stackable:
		var existing_stack: Item= get_item_by_name(item_name)
		if existing_stack:
			existing_stack.quantity += quantity
			return true
			
	if get_size() < max_size:
		var new_item: Item = item.duplicate_custom()
		new_item.quantity = quantity
		items.append(new_item)
		updated.emit()
		return true
		
	return false

func add_item(item: Item) -> bool:
	if not item:
		return false
	return add_item_by_name(item.name, item.quantity)
	
func remove_item(item: Item) -> bool:
	if not item:
		return false
	if item and item.quantity >= 1:
		item.quantity -= 1
		updated.emit()
		return true
	items.erase(item)
	return true

func get_quantity(item: Item) -> int:
	return item.quantity
