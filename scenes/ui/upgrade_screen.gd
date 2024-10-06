extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scenes: PackedScene

@onready var card_container: HBoxContainer = $%CardContainer


func _ready() -> void:
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay: float = 0.0
	for upgrade in upgrades:
		var card_instance: PanelContainer = upgrade_card_scenes.instantiate() as PanelContainer
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		card_instance.selected.connect(_on_upgrade_selected.bind(upgrade))
		delay += 0.2
		
		
func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
