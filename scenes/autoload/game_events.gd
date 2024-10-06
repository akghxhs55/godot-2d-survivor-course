extends Node

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrade: Dictionary)
signal player_damaged


func emit_experience_vial_collected(number: float) -> void:
	experience_vial_collected.emit(number)
	
	
func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrade: Dictionary) -> void:
	ability_upgrade_added.emit(upgrade, current_upgrade)


func emit_player_damaged() -> void:
	player_damaged.emit()
