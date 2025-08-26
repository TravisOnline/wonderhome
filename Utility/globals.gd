extends Node

enum States{
	FIELD,
	BATTLE,
}

const GAME_SIZE: Vector2 = Vector2(640, 360)
const CELL_SIZE: Vector2 = Vector2(32, 32)

var current_map: TileMapLayer = null
#var clock: Clock = null
var target_cell: Vector2 = Vector2.ZERO
var textbox: Textbox = null
var camera: Camera2D = null
var screen_shake: ScreenShake2D = null
var music_position: float = 0.0
var state: int = 0
#var grid_cursor: GridCursor = null
var menu_has_focus: bool = false
var worldplayer: WorldPlayer = null
var world_cam: WorldCam = null
