extends Node

@export var max_speed: int = 40
@export var acceleration: int = 5

var velocity: Vector2 = Vector2.ZERO


func accelerate_to_player(delta: float) -> void:
	var owner_node2d: Node2D = owner as Node2D
	if owner_node2d == null:
		return
		
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var direction: Vector2 = (player.global_position - owner_node2d.global_position).normalized()
	_accelerate_in_direction(direction, delta)


func move(charactor_body: CharacterBody2D) -> void:
	charactor_body.velocity = velocity
	charactor_body.move_and_slide()
	velocity = charactor_body.velocity


func _accelerate_in_direction(direction: Vector2, delta: float) -> void:
	var desired_velocity: Vector2 = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * delta))
