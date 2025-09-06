class_name LoadingScreen extends CanvasLayer

signal transition_incomplete

@onready var anim_player : AnimationPlayer = $AnimationPlayer

var starting_animation_name : String

const LOADWAITTIME : int = 3

func start_transition(animation_name:String) -> void:
	if !anim_player.has_animation(animation_name):
		animation_name = "fade_to_black"
	starting_animation_name = animation_name
	anim_player.play(animation_name)

func finish_transition() -> void:
	var ending_animation_name : String = starting_animation_name.replace("to","from")
	
	if !anim_player.has_animation(ending_animation_name):
		ending_animation_name = "fade_from_black"
	anim_player.play(ending_animation_name)
	
	await anim_player.animation_finished
	queue_free()

func report_midpoint() -> void:
	transition_incomplete.emit()
