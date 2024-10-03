extends Node

@export var end_screen_scene: PackedScene = null


func _ready() -> void:
	$%Player.health_component.died.connect(_on_player_died)
	
	
func _on_player_died() -> void:
	var end_screen_instance: CanvasLayer = end_screen_scene.instantiate() as CanvasLayer
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
