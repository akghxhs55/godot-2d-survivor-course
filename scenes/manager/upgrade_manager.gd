extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var _current_upgrades: Dictionary = {}


func _ready() -> void:
	experience_manager.level_up.connect(_on_level_up)
	
	
func _on_level_up(current_level: int) -> void:
	var chosen_upgrade = upgrade_pool.pick_random()
	if chosen_upgrade == null:
		return
		
	var upgrade_screen_instance: CanvasLayer = upgrade_screen_scene.instantiate() as CanvasLayer
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades([chosen_upgrade] as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(_on_upgrade_selected)
	
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade: bool = _current_upgrades.has(upgrade.id)
	if !has_upgrade:
		_current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		_current_upgrades[upgrade.id]["quantity"] += 1
	
	GameEvents.emit_ability_upgrade_added(upgrade, _current_upgrades)
	
	
func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)
