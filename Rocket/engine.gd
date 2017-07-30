extends Timer

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if get_time_left() > get_wait_time() * 0.5:
		get_parent().set_game_state(1)
	elif get_time_left() > get_wait_time() * 0.25:
		get_parent().set_game_state(2)
	else:
		get_parent().set_game_state(3)