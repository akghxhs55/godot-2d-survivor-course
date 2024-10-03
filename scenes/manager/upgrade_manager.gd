extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var _current_upgrades: Dictionary = {}


func _ready() -> void:
	experience_manager.level_up.connect(_on_level_up)
	
	
func _apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade: bool = _current_upgrades.has(upgrade.id)
	if !has_upgrade:
		_current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		_current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity: int = _current_upgrades[upgrade.id]["quantity"]
		if current_quantity >= upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(
				func(pool_upgrade: AbilityUpgrade) -> bool:
					return pool_upgrade.id != upgrade.id
			)
		
	if upgrade is Ability:
		for ability_upgrade in upgrade.ability_upgrades:
			upgrade_pool.append(ability_upgrade)
	
	GameEvents.emit_ability_upgrade_added(upgrade, _current_upgrades)

	
func _pick_upgrade() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades: Array[AbilityUpgrade] = upgrade_pool.duplicate()
	
	for i in 3:
		if filtered_upgrades.size() == 0:
			break
		var chosen_upgrade: AbilityUpgrade = filtered_upgrades.pick_random() as AbilityUpgrade
			
		filtered_upgrades = filtered_upgrades.filter(
			func(upgrade: AbilityUpgrade) -> bool:
				return upgrade.id != chosen_upgrade.id
		)
		
		chosen_upgrades.append(chosen_upgrade)
		
	return chosen_upgrades


func _on_level_up(current_level: int) -> void:
	var upgrade_screen_instance: CanvasLayer = upgrade_screen_scene.instantiate() as CanvasLayer
	add_child(upgrade_screen_instance)
	var chosen_upgrades: Array[AbilityUpgrade] = _pick_upgrade()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(_on_upgrade_selected)
	
	
func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	_apply_upgrade(upgrade)
