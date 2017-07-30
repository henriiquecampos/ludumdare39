extends RigidBody2D

export (int, "NORMAL", "OPTIMAL", "FALLING") var ENGINE_STATE  = 0 setget set_engine_state
export (float) var min_time = 1.0
export (float) var max_time = 3.0
export (NodePath) var camera_path
onready var tapping = get_node("TappingTimer")
onready var sprite = get_node("Sprite")
var already_pressed = false
var tapped = 0
var needed_tappings = 5

func _ready():
	randomize()
	get_node("CameraRig").set_remote_node("../%s" %camera_path)
	set_fixed_process(true)
	
func _fixed_process(delta):
	manage_inputs()
	already_pressed = Input.is_action_pressed("tapping")
	
func set_engine_state(state):
	if is_inside_tree():
		if state == 0:
			sprite.get_node("ThrustFailing").stop()
			get_node("Particles").set_emitting(false)
		elif state == 1:
			flicking_thrust()
			get_node("Particles").set_emitting(true)
		elif state == 2:
			sprite.get_node("Thrust").set_hidden(true)
			sprite.get_node("ThrustFailing").stop()
			get_node("Particles").set_emitting(true)
	ENGINE_STATE = state

func flicking_thrust():
	sprite.get_node("ThrustFailing").set_wait_time(rand_range(0.1,0.3))
	sprite.get_node("ThrustFailing").start()

func _on_thrust_fail():
	if sprite.get_node("Thrust").is_hidden():
		sprite.get_node("Thrust").set_hidden(false)
	else:
		sprite.get_node("Thrust").set_hidden(true)
	flicking_thrust()

func manage_inputs():
	if ENGINE_STATE == 0:
		if tapping.get_time_left() < tapping.get_wait_time() * 0.5:
			set_engine_state(1)
		if Input.is_action_pressed("tapping") and already_pressed:
			if abs(get_linear_velocity().y) < 400:
				sprite.get_node("Thrust").set_hidden(false)
				set_linear_velocity(get_linear_velocity() + Vector2(0, -100))
		elif not Input.is_action_pressed("tapping") and already_pressed:
			sprite.get_node("Thrust").set_hidden(true)
			set_engine_state(2)
			tapping.stop()
			tapped = 0
	elif ENGINE_STATE == 1:
		if tapping.get_time_left() < tapping.get_wait_time() * 0.25:
			set_engine_state(2)
			get_node("CameraRig").set_remote_node(".")
			sprite.get_node("ThrustFailing").stop()
		if Input.is_action_pressed("tapping") and not already_pressed:
			set_linear_velocity(get_linear_velocity() + Vector2(0, -400))
			restart_tapping()
			set_engine_state(0)
	elif ENGINE_STATE == 2:
		if Input.is_action_pressed("tapping") and not already_pressed:
			tapped += 1
			if tapped >= needed_tappings:
				set_engine_state(0)
				restart_tapping()
				set_linear_velocity(Vector2(0, 0))
				get_node("CameraRig").set_remote_node("../%s" %camera_path)
				tapped = 0
				
func restart_tapping():
	tapping.set_wait_time(rand_range(min_time, max_time))
	tapping.start()

