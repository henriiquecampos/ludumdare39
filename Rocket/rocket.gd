extends RigidBody2D

const MAX_VELOCITY = -400

export (Vector2) var tapping_speed = Vector2(0, -200)
export (float) var min_time = 0.5
export (float) var max_time = 3.0

export (NodePath) var tapping_path
export (NodePath) var reaction_path
export (NodePath) var camera_path
onready var tapping = get_node(tapping_path)
onready var reaction = get_node(reaction_path)
onready var camera = get_node(camera_path)
onready var sprite = get_node("Sprite")

var needed_tappings = 1
var tappings = 0
var already_pressed = false
var bonus_velocity = true
var can_tap = false
var velocity = Vector2(0, -400)
func _ready():
	randomize()
	set_fixed_process(true)
	tapping.set_wait_time(_randomize_time())
	tapping.start()
	
func _fixed_process(delta):
	_set_camera()
	if can_tap:
		if Input.is_action_pressed("tapping") and not already_pressed:
			if tappings >= needed_tappings:
				if get_linear_velocity().y > MAX_VELOCITY:
					if reaction.get_time_left() > 0:
						velocity = Vector2(0, MAX_VELOCITY)
					else:
						velocity = tapping_speed
						set_linear_velocity(get_linear_velocity() + velocity)
					can_tap = false
					get_node("Particles").set_emitting(true)
			else:
				tappings += 1
	else:
		if Input.is_action_pressed("tapping") and already_pressed:
			sprite.get_node("Thrust").set_hidden(false)
			set_linear_velocity(velocity)
			get_node("Particles").set_emitting(false)
	already_pressed = Input.is_action_pressed("tapping")

func _on_tapping_timeout():
	#Engine failing
	flick_thrust()
	_randomize_ignition()
	get_node("Particles").set_emitting(false)
	velocity = Vector2(0, 0)
	can_tap = true
	bonus_velocity = true
	tapping.set_wait_time(_randomize_time())
	tapping.start()
	reaction.start()

func _on_reaction_timeout():
	bonus_velocity = false

func _on_exit_screen():
	get_tree().change_scene("res://Screens/GameOver.tscn")
	
func _set_camera():
	if get_linear_velocity().normalized().y > 0:
		get_node("CameraRig").set_remote_node(".")
	else:
		get_node("CameraRig").set_remote_node(camera.get_path())

func _on_body_enter( body ):
	if body.is_in_group("arrival"):
		get_node("Visibility").disconnect("exit_screen", self, "_on_exit_screen")
		get_tree().change_scene("res://Screens/MainMenu.tscn")

func _randomize_time():
	return(rand_range(min_time, max_time))

func _randomize_ignition():
	needed_tappings = int(rand_range(5,11))
	
func flick_thrust():
	get_node("Particles").set_emitting(true)
	sprite.get_node("ThrustFailing").set_wait_time(rand_range(0.1,0.3))
	sprite.get_node("ThrustFailing").start()
	if can_tap:
		sprite.get_node("ThrustFailing").set_one_shot(true)
		if sprite.get_node("Thrust").is_hidden():
			sprite.get_node("Thrust").set_hidden(false)
		else:
			sprite.get_node("Thrust").set_hidden(true)
	else:
		sprite.get_node("ThrustFailing").set_one_shot(false)