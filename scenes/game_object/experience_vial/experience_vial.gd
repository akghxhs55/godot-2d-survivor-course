extends Node2D

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)
	
	
func _on_area_entered(other_area: Area2D):
	var tween: Tween = create_tween()
	$Area2D.area_entered.disconnect(_on_area_entered)
	tween.tween_method(_tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.05)\
		.set_delay(0.45)
	tween.chain()
	tween.tween_callback(_collect)
	
	
func _tween_collect(percent: float, start_position: Vector2) -> void:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	global_position = start_position.lerp(player.global_position, percent)
	
	var direction: Vector2 = player.global_position - global_position
	var target_rotation: float = direction.angle() + PI / 2
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func _collect() -> void:
	GameEvents.emit_experience_vial_collected(1)
	queue_free()
