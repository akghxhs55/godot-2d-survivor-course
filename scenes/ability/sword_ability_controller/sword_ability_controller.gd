extends Node

@export var max_range: float = 200.0

@export var sword_ability_scene: PackedScene = null

var damage: float = 5.0


func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)
	
	
func _on_timer_timeout() -> void:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(
		func(enemy: Node2D):
			return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2)
	)
	if enemies.size() == 0:
		return

	enemies.sort_custom(
		func(a: Node2D, b: Node2D):
			var a_distance: float = a.global_position.distance_squared_to(player.global_position)
			var b_distance: float = b.global_position.distance_squared_to(player.global_position)
			return a_distance < b_distance
	)
	
	var sword_instance: Node2D = sword_ability_scene.instantiate() as SwordAbility
	var foreground_layer: Node2D = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage

	sword_instance.global_position = enemies[0].global_position

	var enemy_direction: Vector2 = enemies[0].global_position - player.global_position
	sword_instance.rotation = enemy_direction.angle()
	
	sword_instance.lifetime = 1.0


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id != "sword_damage":
		return

	damage = 5.0 + current_upgrades["sword_damage"]["quantity"] * 0.5
