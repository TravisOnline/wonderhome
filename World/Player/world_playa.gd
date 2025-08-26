class_name WorldPlayer extends CharacterBody2D

@onready var cam_follow_node: RemoteTransform2D = $CamFollowNode
@onready var animation_tree: AnimationTree = $AnimationTree
@export var speed: int = 200

var input_vector
var anim_playback: AnimationNodeStateMachinePlayback
# Access this var to change starting direction
var starting_direction:Vector2 = Vector2(0,1)

func _ready() -> void:
	if cam_follow_node:
		cam_follow_node.set_remote_node(Globals.world_cam.get_path())
	anim_playback = animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void:
	input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector * speed
	move_and_slide()
	select_animation()
	update_animation_parameters()

func update_animation_parameters() -> void:
	if input_vector == Vector2.ZERO:
		return
		
	animation_tree["parameters/Idle/blend_position"] = input_vector
	animation_tree["parameters/Walk/blend_position"] = input_vector

func select_animation() -> void:
	if velocity == Vector2.ZERO:
		anim_playback.travel("Idle")
	else:
		anim_playback.travel("Walk")
	
	
