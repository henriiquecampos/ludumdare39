extends Control

var right_already = false
var left_already = false
var tap_already = false
export (Texture) var first
export (Texture) var second
export (Texture) var third
export (Texture) var forth
export (Texture) var tfirst
export (Texture) var tsecond
export (Texture) var tthird
export (Texture) var tforth
onready var textures = [first, second, third, forth]
onready var thrust = [tfirst, tsecond, tthird, tforth]
var current = 0
onready var player = get_tree().get_nodes_in_group("player")[0].get_node("Sprite")
func _ready():
	get_tree().set_pause(true)
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("ui_right") and not right_already:
		_on_Next_released()
	elif Input.is_action_pressed("ui_left") and not left_already:
		_on_Previous_released()
	elif Input.is_action_pressed("tapping") and not tap_already:
		get_node("../../SFX").play("init")
		get_node("../../Init").set_process(true)
		get_node("../../Animator").play("Init")
		bgm.fade_volume()
		queue_free()

	tap_already = Input.is_action_pressed("tapping")
	right_already = Input.is_action_pressed("ui_right") 
	left_already = Input.is_action_pressed("ui_left") 

func _on_Previous_released():
	if current > 0:
		current -= 1
	player.set_texture(textures[current])
	player.get_node("Thrust").set_texture(thrust[current])
func _on_Next_released():
	if current < textures.size() -1:
		current += 1
	player.set_texture(textures[current])
	player.get_node("Thrust").set_texture(thrust[current])
