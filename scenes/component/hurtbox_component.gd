extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent

var floating_text_scene: PackedScene = preload("res://scenes/ui/floating_text.tscn")


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
	
func _on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent:
		return
		
	if health_component == null:
		return
		
	var hitbox_component: HitboxComponent = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
	
	var floating_text: Node2D = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position + Vector2.UP * 4
	floating_text.start(str(hitbox_component.damage))
	
	hit.emit()
