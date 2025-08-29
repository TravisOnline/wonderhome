extends Control
# HAndles UI elements/selecting abilities and enemies/party members etc
const Actions: Dictionary = EventQueue.Actions

var party: Array = PlayerData.party
var current_action: EventQueue.Actions = -1
var current_player_index: int = -1
var current_item: Item = null

@onready var event_queue: EventQueue = $EventQueue
@onready var options: Menu = $PlayerWindow/Options
@onready var enemies_holder: Menu = $EnemiesHolder
@onready var player_h_box_container: PlayerWindows = $PlayerWindow/PlayerHBoxContainer
@onready var inventory_panel_container: InventoryMenu = $PlayerWindow/InventoryPanelContainer

# TODO: Refactor this. Probably don't need to check every frame and can do it after every turn
#func _physics_process(delta: float) -> void:

func _ready() -> void:
	goto_next_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# TODO: make it so the item menu can close if no items are present.
		# This is likely that this menu is no longer in focus because the curosor is not present.
		if enemies_holder.close() or player_h_box_container.close() or inventory_panel_container.close(true):
			options.button_focus()
		elif current_player_index > 0 and options.menu_is_focused():
			event_queue.pop_back()
			goto_next_player(-1)
		else:
			pass
			
		get_viewport().set_input_as_handled()
	

func goto_next_player(dir: int = 1) -> void:
	dir = clampi(dir, -1, 1)
	current_player_index += dir
	current_player_index = clampi(current_player_index, 0, party.size())
	inventory_panel_container.hide()
	
	# IF all player have moved, let AI do things
	if current_player_index >= party.size():
		for enemy: EnemyHolder in enemies_holder.get_buttons():
			var actor: BattleActor = enemy.data
			# Target random member of party to attack
			var target: BattleActor = party.pick_random()
			# TODO: Add AI enemy abilities or whatever else
			event_queue.add(Actions.ATTACK, actor, target, null)
		
		options.hide()
		if get_viewport().gui_get_focus_owner():
			get_viewport().gui_get_focus_owner().release_focus()
		player_h_box_container.activate(-1)
		#print("DEBUG: Total events in queue: ", event_queue.events.size())
		await(event_queue.run())
		current_player_index = 0

	current_action = -1
	current_item = null
	player_h_box_container.activate(current_player_index)
	options.button_focus()

func _on_options_button_pressed(button: BaseButton, _index: int) -> void:
	match button.text:
		"Attack":
			current_action = Actions.ATTACK
			enemies_holder.button_focus()
		"Item":
			current_action = Actions.ITEM
			inventory_panel_container.inventory = party[current_player_index].inventory
			print(inventory_panel_container.inventory)
			inventory_panel_container.button_focus()
		_:
			pass

func _on_inventory_panel_container_button_pressed(button: BaseButton, _index: int) -> void:
	if button.item:
		current_item = button.item
		player_h_box_container.button_focus(0)

func _on_enemies_holder_button_pressed(button: BaseButton, _index: int) -> void:
	# Send current_action to event queue node
	event_queue.add(current_action, party[current_player_index], button.data, current_item)
	goto_next_player()

func _on_player_h_box_container_button_pressed(button: BaseButton, _index: int) -> void:
	event_queue.add(current_action, party[current_player_index], button.data, current_item)
	goto_next_player()
