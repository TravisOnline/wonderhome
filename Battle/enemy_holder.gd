class_name EnemyHolder extends TextureButton

@export var data: BattleActor = null : 
	set(value):
		data = value.copy()
		data.hp_changed.connect(_on_data_hp_changed)
		texture_normal = data.sprite
		
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")

func _process(delta: float) -> void:
	# TODO: Remove this efect. Used to show enemy hit flash.
	# Will need to remove timer from the prefab as well
	pass

func _on_focus_entered() -> void:
	animation_player.play("TargetHighlight")

func _on_focus_exited() -> void:
	animation_player.play("RESET")

func _on_data_hp_changed(hp: int, _hp_max: int, _value_change: int)-> void:
	if hp <= 0:
		self.hide()
		#queue_free()
		# TODO: Add particle effect/screenshake whatever for when damaged
		# Func.start() etc
