extends Node2D
class_name SwordAbility

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var lifetime: float = 1.0


func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
