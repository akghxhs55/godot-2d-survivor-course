extends CanvasLayer

@onready var panel_container: PanelContainer = $%PanelContainer


func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	$%ContinueButton.pressed.connect(_on_continue_button_pressed)
	$%QuitButton.pressed.connect(_on_quit_button_pressed)
	
	
func set_victory() -> void:
	$%TitleLabel.text = "Victory"
	$%DescriptionLabel.text = "You have won!"
	_play_jingle_victory()

	
func set_defeat() -> void:
	$%TitleLabel.text = "Defeat"
	$%DescriptionLabel.text = "You have been defeated!"
	_play_jingle_defeat()

	
func _on_continue_button_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")
	
	
func _on_quit_button_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false


func _play_jingle_victory():
	$VictoryStreamPlayer.play()


func _play_jingle_defeat():
	$DefeatStreamPlayer.play()
