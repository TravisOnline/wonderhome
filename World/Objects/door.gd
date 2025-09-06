class_name Door extends Area2D

signal player_entered_door(door:Door, transition_type:String)

@export_enum("north", "east", "south", "west") var entry_direction
@export_enum("fade_to_black", "wipe_to_right") var transition_type:String
@export var push_distance : int = 16
@export var path_to_new_scene : String
@export var entry_door_name : String

func _on_body_entered(body : Node2D) -> void:
	if not body is WorldPlayer:
		return
	player_entered_door.emit(self)
	if transition_type == "zelda":
		SceneManager.load_level_zelda(path_to_new_scene)
	else:
		SceneManager.load_new_scene(path_to_new_scene,transition_type)
	queue_free()
	
func get_player_entry_vector() -> Vector2:
	var vector:Vector2 = Vector2.LEFT
	match entry_direction:
		0:
			vector = Vector2.UP
		1:
			vector = Vector2.LEFT
		2:
			vector = Vector2.DOWN
	return (vector * push_distance) + self.position
	
func get_move_dir() -> Vector2:
	var dir : Vector2 = Vector2.RIGHT
	match entry_direction:
		0:
			dir = Vector2.DOWN
		1:
			dir = Vector2.LEFT
		2:
			dir = Vector2.UP
	return dir
