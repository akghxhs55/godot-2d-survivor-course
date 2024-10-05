extends CharacterBody2D

const MAX_SPEED: int = 75

@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals: Node2D = $Visuals


func _process(delta: float) -> void:
	var direction: Vector2 = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()
	
	var move_sign = sign(direction.x)
	if move_sign != 0:
		visuals.scale.x = move_sign
	
	
func get_direction_to_player() -> Vector2:
	var player_node := get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
