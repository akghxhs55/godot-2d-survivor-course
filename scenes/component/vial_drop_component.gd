extends Node

@export_range(0.0, 1.0) var drop_percent: float = 0.5
@export var healthComponent: Node
@export var vial_scene: PackedScene


func _ready() -> void:
	if healthComponent == null:
		return
	(healthComponent as HealthComponent).died.connect(_on_died)
	
	
func _on_died() -> void:
	if randf() > drop_percent:
		return
		
	if vial_scene == null:
		return
		
	if not owner is Node2D:
		return
		
	var vial_instance: Node2D = vial_scene.instantiate() as Node2D
	var spawn_position: Vector2 = (owner as Node2D).global_position
	vial_instance.global_position = spawn_position
	
	var entities_layer: Node2D = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
