class_name EnemyActor extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var battle_id: int = 0

var _moved_this_frame: bool = false
var anim_playback: AnimationNodeStateMachinePlayback
var travel_direction: Vector2

func _ready() -> void:
	anim_playback = animation_tree["parameters/playback"]
	navigation_agent_2d.velocity_computed.connect(_on_agent_velocity_computed)

func _physics_process(_delta: float) -> void:
	travel_direction = velocity.normalized()
	#print(velocity.length())
	update_animation_parameters()
	select_animation()
	_post_physics_process.call_deferred()
	
func _post_physics_process() -> void:
	if not _moved_this_frame:
		velocity = Vector2.ZERO
	_moved_this_frame = false
	
func move(p_velocity: Vector2) -> void:
	navigation_agent_2d.set_velocity(p_velocity)
	move_and_slide()
	_moved_this_frame = true

func update_animation_parameters() -> void:
	if travel_direction == Vector2.ZERO:
		return
	
	var discrete_direction = get_8_directional_vector(travel_direction)
	animation_tree["parameters/Idle/blend_position"] = discrete_direction
	animation_tree["parameters/Walk/blend_position"] = discrete_direction

func select_animation() -> void:
	if velocity == Vector2.ZERO:
		anim_playback.travel("Idle")
	else:
		anim_playback.travel("Walk")

func get_8_directional_vector(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO:
		return Vector2.ZERO
	
	var angle = direction.angle()
	# Convert the direction to 8 way movement for animations
	var dir_index = round(angle / (PI / 4.0))
	var new_angle = dir_index * (PI / 4.0)
	
	return Vector2.from_angle(new_angle)

func _on_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("world_playa"):
		BattleHolder.construct_scene(battle_id, self)
