extends Node2D
class_name KnifeAbility

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var speed: float = 150.0
var lifetime: float = 1.0


func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2(speed, 0).rotated(rotation)
	global_position += velocity * delta
		
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
