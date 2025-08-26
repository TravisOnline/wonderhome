class_name BattleActor extends Resource

signal hp_changed(hp, hp_max, acmount_changed)

@export var sprite: Texture = null
@export var name: String = ""
@export var hp_max: int = 1
@export var sp_max: int = 1
@export var attack: int = 2
@export var defense: int = 1
@export var items: Array[Item] = []
#@export var xp: int = 1
#@export var money: int = 1
@export var drops: Array[Item] = []

var hp:int = hp_max
var sp:int = sp_max
var inventory: Inventory = null

func init() -> void:
	hp = hp_max
	sp = sp_max
	
	if items: 
		inventory = Inventory.new()
		var j: int = 0
		for i: Item in items:
			j += 1
			inventory.add_item(i)

# No idea why, but the hp_max will not be set from default
# value unless we create a copy of this object and re-init
func copy() -> BattleActor:
	var dup: BattleActor = duplicate()
	dup.init()
	return dup

func is_defeated() -> bool:
	return hp <= 0

func can_act() -> bool:
	return !is_defeated()

func damage_roll(target: BattleActor) -> int:
	return -attack + target.defense

func healhurt(value: int) -> int:
	var previous_hp: int = hp
	hp += value
	
	var value_change: int = previous_hp - hp
	hp = clampi(hp, 0, hp_max)
	hp_changed.emit(hp, hp_max, value_change)
	#print(name, " ", hp)
	return value_change
