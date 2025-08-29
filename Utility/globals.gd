extends Node

enum States{
	FIELD,
	BATTLE,
}

const GAME_SIZE: Vector2 = Vector2(640, 360)

var textbox: Textbox = null
var main_camera: Camera2D = null
var current_scene : Node = null
#var screen_shake: ScreenShake2D = null
var music_position: float = 0.0
var state: int = 0
var menu_has_focus: bool = false
var worldplayer: WorldPlayer = null
var world_cam: WorldCam = null
var attacking_enemy: EnemyActor = null
