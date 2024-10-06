extends CanvasLayer

@onready var panel_container: PanelContainer = $%PanelContainer

var options_menu_scene: PackedScene = preload("res://scenes/ui/options_menu.tscn")
var is_closing: bool = false


func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	
	$%ResumeButton.pressed.connect(_on_resume_pressed)
	$%OptionsButton.pressed.connect(_on_options_pressed)
	$%QuitButton.pressed.connect(_on_quit_pressed)
	
	$AnimationPlayer.play("default")
	
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_close()
		get_tree().root.set_input_as_handled()
	
	
func _on_resume_pressed() -> void:
	_close()
	
	
func _on_options_pressed() -> void:
	var options_menu_instance: CanvasLayer = options_menu_scene.instantiate() as CanvasLayer
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(_on_options_back_pressed.bind(options_menu_instance))
	
	
func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	
	
func _on_options_back_pressed(options_menu: Node) -> void:
	options_menu.queue_free()
	
	
func _close() -> void:
	if is_closing:
		return
	is_closing = true
	
	$AnimationPlayer.play_backwards("default")

	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	await tween.finished
	
	get_tree().paused = false
	queue_free()
	
