extends Node

@export var max_range: float = 150.0

@export var knife_ability: PackedScene

var damage: float = 5.0
var speed: float = 150.0
var base_wait_time: float


func _ready() -> void:
	base_wait_time = $Timer.wait_time 
	$Timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
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
		
	var knife_instance: Node2D = knife_ability.instantiate() as KnifeAbility
	var foreground_layer: Node2D = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(knife_instance)
	knife_instance.hitbox_component.damage = damage

	knife_instance.global_position = player.global_position
	
	var enemy_direction: Vector2 = enemies[0].global_position - player.global_position
	knife_instance.rotation = enemy_direction.angle()

	knife_instance.speed = speed
	knife_instance.lifetime = 1.0


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id != "knife_rate":
		return
		
	var percent_reduction = current_upgrades["knife_rate"]["quantity"] * 0.1
	$Timer.wait_time = base_wait_time * (1.0 - percent_reduction)
	$Timer.start()
