extends Node

var backgrounds : Dictionary = {}

# Spawnable enemies hold every battle enemy actor on the game. The _construct_battle_tables
# Groups and assigns these enemies to pre-constructed battles to load from battle_tables.
# The construct_scene function receives an int which points this class to the array value
# containing the battle to load.
var spawnable_enemies : Dictionary = {}
var battle_tables : Array[Dictionary]  = []

var battle_scene_enemies_holder: Menu =null
var instantiated_battle : Node = null

# Tracks which enemy in the overworld initiated the battle in order to mark them as defeated
# In the overworld. Set in construct_scene
var world_enemy_actor : EnemyActor

const BATTLE_TEMPLATE_SCENE = preload("res://Battle/Battle.tscn")
const ENEMY_HOLDER_TEMPLATE = preload("res://Battle/enemy_holder.tscn")

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

func construct_scene(battle_to_construct:int, enemy_actor_node: EnemyActor) -> void:
	if enemy_actor_node:
		world_enemy_actor = enemy_actor_node
		
	Globals.current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	#TODO: Trigger visual FX in environment
	
	instantiated_battle = BATTLE_TEMPLATE_SCENE.instantiate()
	battle_scene_enemies_holder = instantiated_battle.get_node("EnemiesHolder")
	
	# TODO: Add for loop for amount of enemies needed per battle
	
	for enemy in battle_tables[battle_to_construct]:
		var instantiated_enemy_holder_template = ENEMY_HOLDER_TEMPLATE.instantiate()
		battle_scene_enemies_holder.add_child(instantiated_enemy_holder_template)
		instantiated_enemy_holder_template.data = battle_tables[battle_to_construct][enemy]
	
	get_tree().get_root().add_child(instantiated_battle)
	get_tree().set_current_scene(instantiated_battle)
	
	var battle_camera = find_camera_in_scene(instantiated_battle)
	if battle_camera:
		battle_camera.make_current()

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
	Globals.current_scene.process_mode = Node.PROCESS_MODE_INHERIT
	# TODO: Add death effects or like trigger the death function or something
	world_enemy_actor.queue_free()
	battle_scene_enemies_holder = null
	get_tree().set_current_scene(Globals.current_scene)
	instantiated_battle.queue_free()

func find_camera_in_scene(scene_node: Node) -> Camera2D:
	if scene_node is Camera2D:
		return scene_node
	for child in scene_node.get_children():
		var found_camera = find_camera_in_scene(child)
		if found_camera:
			return found_camera
	return null

func check_battle_over() -> void:
	if battle_scene_enemies_holder:
		if !battle_scene_enemies_holder._check_enemies_alive():
			end_battle()
