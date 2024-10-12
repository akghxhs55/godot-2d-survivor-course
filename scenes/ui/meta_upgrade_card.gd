extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var purchase_button: Button = $%PurchaseButton
@onready var progress_label: Label = $%ProgressLabel
@onready var count_label: Label = $%CountLabel
@onready var progress_bar: ProgressBar = $%ProgressBar

var upgrade: MetaUpgrade 


func _ready() -> void:
	purchase_button.pressed.connect(_on_purchase_button_pressed)


func set_meta_upgrade(upgrade_target: MetaUpgrade) -> void:
	upgrade = upgrade_target
	name_label.text = upgrade_target.title
	description_label.text = upgrade_target.description
	update_progress()
	
	
func update_progress() -> void: 
	var current_quantity: int = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	var currency: float = MetaProgression.save_data["meta_upgrade_currency"]
	var percent: float = min(currency / upgrade.experience_cost, 1)
	
	var is_maxed: bool = current_quantity >= upgrade.max_quantity
	purchase_button.disabled = percent < 1 or is_maxed
	
	progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	if is_maxed:
		count_label.text = "Max"
	else:
		count_label.text = "x%d" % current_quantity
	progress_bar.value = percent


func _on_purchase_button_pressed() -> void:
	if upgrade == null:
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")


func _select_card() -> void:
	$AnimationPlayer.play("selected")
