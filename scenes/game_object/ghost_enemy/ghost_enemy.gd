extends CharacterBody2D

@onready var visuals: Node2D = $Visuals
@onready var velocity_component = $VelocityComponent


func _ready() -> void:
	$HurtboxComponent.hit.connect(_on_hit)


func _process(delta: float) -> void:
	velocity_component.accelerate_to_player(delta)
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale.x = move_sign
		
		
func _on_hit() -> void:
	$HitRandomStreamPlayer2DComponent.play_random()
