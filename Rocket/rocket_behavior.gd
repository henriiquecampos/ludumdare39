extends RigidBody2D

export (int, 'INIT', 'NORMAL', 'FAILING', 'FAILED') var game_state = 0 setget set_game_state, get_game_state
var velocity = Vector2(0, -400)
func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	set_linear_velocity(get_linear_velocity() + velocity * delta)

func set_game_state(value):
	if is_inside_tree():
		if value == 1:
			print("NORMAL")
			velocity = Vector2(0, -1000)
		elif value == 2:
			velocity = Vector2(0, -500)
			print("FAILING")
		elif value == 3:
			velocity = Vector2(0, 0)
			print("FAILED")
	game_state = value

func get_game_state():
	return(game_state)

func _on_body_enter( body ):
	pass

func _on_input_tap():
	pass

func _on_input_release():
	pass