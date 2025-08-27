extends Node

var spawnable_enemies : Dictionary = {}
var backgrounds : Dictionary = {}
var battle_tables : Array[Dictionary]  = []
const battle_template_scene = preload("res://Battle/Battle.tscn")
const enemy_holder_template = preload("res://Battle/enemy_holder.tscn")
@onready var main_scene = preload("res://Rooms/debug_world.tscn")

func _ready() -> void:
	load_resources_to_dict("res://Battle/Enemies/", spawnable_enemies)
	Util.set_keys_to_names(spawnable_enemies)
	_construct_battle_tables()

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

func construct_scene() -> void:
	# Pause current scene in BG
	var current_scene = get_tree().current_scene
	
	current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	#TODO: Trigger visual FX in environment
	
	var instantiated_battle = battle_template_scene.instantiate()
	var battle_scene_enemies_holder: Menu = instantiated_battle.get_node("EnemiesHolder")
	
	# TODO: Add for loop for amount of enemies needed per battle
	
	var instantiated_enemy_holder_template = enemy_holder_template.instantiate()
	battle_scene_enemies_holder.add_child(instantiated_enemy_holder_template)
	instantiated_enemy_holder_template.data = spawnable_enemies["debug_zombie"]
	
	get_tree().get_root().add_child(instantiated_battle)
	get_tree().set_current_scene(instantiated_battle)
	
	var battle_camera = find_camera_in_scene(instantiated_battle)
	if battle_camera:
		print("Found camera ", battle_camera, " in ", instantiated_battle)
		battle_camera.priority = 1
		battle_camera.global_position = Vector2(0, 0)

# For debugging 
func _print_enemy_dict() -> void:
	for i in spawnable_enemies:
		print(i)

# For debugging
func _print_battle_table() -> void:
	for i in battle_tables:
		print(i)

func _construct_battle_tables() -> void:
	battle_tables.append({"actor_01": spawnable_enemies["debug_zombie"]})
	battle_tables.append({"actor_01": spawnable_enemies["debug_zombie"], "actor_02": spawnable_enemies["debug_zombie"]})

func end_battle():
	var previous_scene = get_meta("previous_scene")
	if previous_scene:
		previous_scene.process_mode = Node.PROCESS_MODE_INHERIT
		get_tree().set_current_scene(previous_scene)
	queue_free()

func find_camera_in_scene(scene_node: Node) -> ScreenShake2D:
	if scene_node is ScreenShake2D:
		return scene_node
	for child in scene_node.get_children():
		var found_camera = find_camera_in_scene(child)
		if found_camera:
			return found_camera
	return null
