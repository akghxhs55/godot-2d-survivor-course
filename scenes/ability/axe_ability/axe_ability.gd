extends Node2D
class_name AxeAbility

const MAX_RADIUS: float = 100.0

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var base_rotation: Vector2 = Vector2.RIGHT


func _ready() -> void:
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween: Tween = create_tween()
	tween.tween_method(_change_position, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)
	
	
func _change_position(value: float) -> void:
	var percentage: float = value / 2.0
	var current_radius: float = MAX_RADIUS * percentage
	var current_direction: Vector2 = base_rotation.rotated(value * TAU)
	
	var root_position: Vector2 = global_position
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		root_position = player.global_position
		
	global_position = root_position + current_direction * current_radius
