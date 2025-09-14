class_name ItemButton extends Button

var item: Item = null :
	set(value):
		item = value
		
		if item:
			text = "%s %d" % [item.name, item.quantity]
		else: 
			hide()
