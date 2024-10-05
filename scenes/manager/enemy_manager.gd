extends Node

const SPAWN_RADIUS: int = 330

@export var basic_enemy_scene: PackedScene
@export var ghost_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer: Timer = $Timer

var base_spawn_time: float = 1.0
var enemy_table: WeightedTable = WeightedTable.new()


func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 100)
	
	base_spawn_time = timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)

	
func _get_spawn_position() -> Vector2:
	var player: Node = get_tree().get_first_node_in_group("player")
	if player == null:
		return Vector2.ZERO
		
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))

	for i in 4:
		var direction: Vector2 = random_direction.rotated(i * (PI / 2))
		var spawn_position: Vector2 = player.global_position + (direction * SPAWN_RADIUS)
		
		var query_parameters: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var query_result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		if query_result.is_empty():
			return spawn_position

	return player.global_position
		

func _on_timer_timeout() -> void:
	timer.start()
	
	var enemy_scene: PackedScene = enemy_table.pick_item()
	var enemy: Node2D = enemy_scene.instantiate() as Node2D
	
	var entities_layer: Node2D = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = _get_spawn_position()
	
	
func _on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_off: float = (1.0 / 12) * arena_difficulty
	timer.wait_time = max(base_spawn_time - time_off, 0.3)
	
	if arena_difficulty == 6:
		enemy_table.add_item(ghost_enemy_scene, 20)
