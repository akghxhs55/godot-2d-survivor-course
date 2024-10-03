extends Node

const SPAWN_RADIUS: int = 330

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer: Timer = $Timer

var base_spawn_time: float = 1.0


func _ready() -> void:
	base_spawn_time = timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)
	

func _on_timer_timeout() -> void:
	timer.start()
	
	var player: Node = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	var enemy: Node2D = basic_enemy_scene.instantiate() as Node2D
	var entities_layer: Node2D = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 = player.global_position + (random_direction * SPAWN_RADIUS)
	enemy.global_position = spawn_position
	
	
func _on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_off: float = (1.0 / 12) * arena_difficulty
	timer.wait_time = max(base_spawn_time - time_off, 0.3)
