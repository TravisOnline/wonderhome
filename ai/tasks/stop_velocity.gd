@tool
extends BTAction

func _tick(_delta: float) -> Status:
	#agent.velocity = 0
	agent.move(Vector2.ZERO)
	return SUCCESS
