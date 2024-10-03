extends Camera2D

var target_position := Vector2.ZERO


func _ready() -> void:
	make_current()


func _process(delta: float) -> void:
	acquireTarget()
	global_position = global_position.lerp(target_position, 1. - exp(-delta * 8))
	

func acquireTarget() -> void:
	var player_node: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		target_position = player_node.global_position
