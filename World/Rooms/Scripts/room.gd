class_name Room extends Node2D

@export var playerholder : Node2D
@export var doors : Array[Door]
@export var enemies : Array[EnemyActor]
var data:LevelDataHandoff
var this_player : WorldPlayer
var this_player_prefab

func _ready() -> void:
	#if Globals.worldplayer:
		#Globals.worldplayer.disable()
		#Globals.worldplayer.visible = false
	if data == null:
		enter_room()

func enter_room() -> void:
	if data != null:
		init_player_location()
	#if Globals.worldplayer:
		#Globals.worldplayer.enable()
	# TODO: Remove when no longer needed for debugging earliest build
	else:
		init_player_location()
	_connect_to_doors()

func init_player_location() -> void:
	var this_player_prefab : PackedScene = Globals.worldplayer_prefab
	this_player = this_player_prefab.instantiate()
	playerholder.add_child(this_player)
	if data != null:
		for door in doors:
			if door.name == data.entry_door_name:
				this_player.position = door.get_player_entry_vector()
				# Set player facing direction to door facing direction
				this_player.animation_tree["parameters/Idle/blend_position"] = door.get_move_dir()
	# User for debugging and starting in a random room
	else:
		this_player.position = Vector2(400, 250)
	this_player = Globals.worldplayer

# Function to handle despawning room upon leaving
func _on_player_entered_door(door:Door) -> void:
	for enemy in enemies:
		if enemy:
			# Throws a note in the debugger, however, if we don't have this the game will freak out
			# If an enemy is dead when trying to pause them
			enemy.PROCESS_MODE_DISABLED
		# TODO: remove this code if enemies do not respawn upon re-enter. May need to redo this
		# entirely if I want to keep their location or move them around when the player is not
		# int the room
			enemy.queue_free()
	_disconnect_from_doors()
	if this_player:
		#this_player.PROCESS_MODE_DISABLED
	# Seems stupid. Will probably need to TODO replace this so my player isn't getting nuked between
	# Rooms
		this_player.queue_free()
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
