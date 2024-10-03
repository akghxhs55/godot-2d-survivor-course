extends Node

@export var axe_ability_scene: PackedScene = null

var damage: float = 10.0
var axe_scale: float = 1.0 


func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	var axe_instance: Node2D = axe_ability_scene.instantiate() as AxeAbility
	var foreground_layer: Node2D = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(axe_instance)
	axe_instance.hitbox_component.damage = damage
	axe_instance.scale = Vector2(axe_scale, axe_scale)


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id != "axe_scale":
		return

	axe_scale = 1.0 + current_upgrades["axe_scale"]["quantity"] * 0.1
