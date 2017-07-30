extends Control

var right_already = false
var left_already = false
export (Texture) var first
export (Texture) var second
export (Texture) var third
var textures = [first, second, third]
func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("ui_right") and not right_already:
		_on_Next_released()
	elif Input.is_action_pressed("ui_left") and not left_already:
		_on_Previous_released()
		
	right_already = Input.is_action_pressed("ui_right") 
	left_already = Input.is_action_pressed("ui_left") 

func _on_Previous_released():
	print("PREVIOUS")


func _on_Next_released():
	print("NEXT")
