class_name Item extends Resource

signal updated(quantity: int)

const TEXTURE: AtlasTexture = null

@export var texture: AtlasTexture = null
@export var quantity: int = 1 :
	set(n):
		quantity = n
		updated.emit(quantity)
		
@export var stackable: bool = true
@export var value: int = 0

var name: String = "ItemNotSet"

func set_name_custom(n:String) -> void:
	name = n

func duplicate_custom() -> Item:
	var dup: Item = self.duplicate()
	dup.name = name
	dup.quantity = quantity
	return dup
