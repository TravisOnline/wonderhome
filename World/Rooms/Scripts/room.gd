class_name Room extends Node2D

@export var doors : Array[Door]
var data:LevelDataHandoff

func _ready() -> void:
	if Globals.worldplayer:
		Globals.worldplayer.disable()
		Globals.worldplayer.visible = false
	if data == null:
		enter_room()
		
func enter_room() -> void:
	if data != null:
		init_player_location()
	if Globals.worldplayer:
		Globals.worldplayer.enable()
	_connect_to_doors()

func init_player_location() -> void:
	if data != null:
		for door in doors:
			if door.name == data.entry_door_name:
				Globals.worldplayer.position = door.get_player_entry_vector()
		Globals.worldplayer.orient(data.move_dir)

func _on_player_entered_door(door:Door) -> void:
	_disconnect_from_doors()
	Globals.worldplayer.disable()
	# Seems stupid. Will probably need to TODO replace this so my player isn't getting nuked between
	# Rooms
	Globals.worldplayer.queue_free()
	data = LevelDataHandoff.new()
	data.entry_door_name = door.entry_door_name
	data.move_dir = door.get_move_dir()
	set_process(false)
	
func _connect_to_doors() -> void:
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)
			
func _disconnect_from_doors() -> void:
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)

func _init() -> void:
	Globals.current_scene = self
