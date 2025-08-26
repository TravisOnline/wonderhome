class_name EventQueue extends Node

enum Actions {
	ATTACK,
	SKILL,
	ITEM,
	DEFEND,
	ESCAPE
}

const SHORT_WAIT_TIME: float = 0.25
const LONG_WAIT_TIME: float = 1.25

var events: Array[Dictionary]  = []

# TODO make it a global textbox I guess
#@onready var textbox: Textbox = Globals.textbox
@onready var battle_info_text_box: Textbox = $"../BattleInfoTextBox"

func add(action: Actions, actor: BattleActor, target: BattleActor, item: Item) -> void:
	events.append({"action": action,"actor": actor,"target": target, "item":item})
	#print("Adding event: ", actor.name, " is ", Actions.keys()[action], " ", target.name, ".", " Item is ", item)

func pop_back() -> void:
	events.pop_back()

func wait(duration: float) -> void:
	await(get_tree().create_timer(duration).timeout)

func run() -> void:
	if events.is_empty():
		battle_info_text_box.stop()
		return
		
	var event: Dictionary = events.pop_front()
	var action: Actions = event.action
	var actor: BattleActor = event.actor
	var target: BattleActor = event.target
	var target_is_friendly: bool = PlayerData.party.has(target)
	var item: Item = event.item
	var text: String = actor.name
	
	# If the actor is dead, do nothing and trigget recursion for next event
	if not actor.can_act():
		await(run())
		return
		
	if target.is_defeated():
		await(run())
		return
		# If I want to change this to instead find random target instead of do
		# nothing, use the following:
		#var party: Array =  PlayerData.party.duplicate()
		#var targets: Array = party
		#var target_is_friendly: bool = party.has(target)
		#
		#if not target_is_friendly:
			#targets.clear()
			#for h: EnemyHolder in get_tree().get_nodes_in_group("battle_screen_enemies"):
				#targets.append(h.data)
		#
		#target = null
		#party.shuffle()
		#for i: BattleActor in party:
			#if not i.is_defeated():
				#target = i
				#break
					#
		#if not target:
			#print_debug("Battle end?")
			#return
		
	#vprint("Event queue running event: ", event.actor.name, " ", Actions.keys()[action], " ", target.name)
	match action:
		Actions.ATTACK:
			var damage: int = actor.damage_roll(target)
			text += " attacks " + target.name + "..."
			battle_info_text_box.start("", [text])
			await(wait(SHORT_WAIT_TIME))
			
			target.healhurt(damage)
			if target_is_friendly:
				Globals.screen_shake.add_trauma()
			if damage > 0:
				battle_info_text_box.add("... " + target.name + " takes no damage!!")
			else:
				battle_info_text_box.add("..." + target.name + " takes " + str(abs(damage)) + " in damage!!")
		Actions.ITEM:
			text += " uses " + item.name + "..."
			battle_info_text_box.start("", [text])
			await(wait(SHORT_WAIT_TIME))
			
			battle_info_text_box.add("... but items is piss")
		_:
			print("Action not found")
			pass
	# Because we're popping the front action, we recur this method
	await(wait(LONG_WAIT_TIME))
	
	if target.is_defeated():
		battle_info_text_box.add(target.name + " is dead.")
		await(wait(LONG_WAIT_TIME))
	await(run())
