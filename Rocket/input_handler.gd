extends Node

var already_pressed = false

signal tapped
signal released
func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	_handle_inputs()
	
func _handle_inputs():
	if Input.is_action_pressed("tapping") and not already_pressed:
		emit_signal("tapped")
	elif not Input.is_action_pressed("tapping") and already_pressed:
		emit_signal("released")
	already_pressed = Input.is_action_pressed("tapping")