extends CanvasLayer

onready var tapping = get_node("../TappingTimer")

export (NodePath) var power_path
onready var power = get_node(power_path)

func _ready():
	set_process(true)
func _process(delta):
	power.set_max(tapping.get_wait_time())
	power.set_value(tapping.get_time_left())