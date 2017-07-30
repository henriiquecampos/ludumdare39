extends Polygon2D

onready var animator = get_node("Animator")
func _ready():
	get_node("SFX").play("init")
	get_tree().set_pause(true)


func _on_Visibility_exit_screen():
	get_tree().set_pause(true)
	animator.play("Lose")


func _on_body_enter( body ):
	if body.is_in_group("player"):
		get_tree().set_pause(true)
		animator.play("Win")