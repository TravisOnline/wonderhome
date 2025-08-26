class_name PlayerWindow extends Button

var tween: Tween = null

@onready var start_y: float = position.y
@onready var player_name_label: Label = $PlayerPanelContainer/VBoxContainer/PlayerNameLabel
@onready var hp_value: Label = $PlayerPanelContainer/VBoxContainer/HPHolder/HP_Value
@onready var sp_value: Label = $PlayerPanelContainer/VBoxContainer/SPHolder/SP_Value

var data: BattleActor = null :
	set(value):
		data = value
		
		if data:
			if data.is_connected("hp_changed", _on_data_hp_changed):
				data.hp_changed.disconnect(_on_data_hp_changed)
			data = data.copy()
			data.hp_changed.connect(_on_data_hp_changed)
			# Can shorten name here. This would only allow the first 8 characters
			# player_name_label.text = data.name.erase(8, 99)
			player_name_label.text = data.name
			hp_value.text = str(data.hp)
			sp_value.text = str(data.sp)
			show()
		else:
			hide()

func activate(on: bool) -> void:
	var target_y: float = start_y
	var duration: float = 0.5
	if on:
		target_y += -8
		
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "position:y", target_y, duration).set_trans(Tween.TRANS_ELASTIC)

func _on_data_hp_changed(hp: int, _hp_max: int, _value_change: int) -> void:
	hp_value.text = str(hp)
