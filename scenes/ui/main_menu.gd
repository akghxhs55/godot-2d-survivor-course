extends CanvasLayer

var options_scene: PackedScene = preload("res://scenes/ui/options_menu.tscn")


func _ready() -> void:
	$%PlayButton.pressed.connect(_on_play_button_pressed)
	$%OptionsButton.pressed.connect(_on_options_button_pressed)
	$%QuitButton.pressed.connect(_on_quit_button_pressed)
	
	
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
	
func _on_options_button_pressed() -> void:
	var options_instance: Node = options_scene.instantiate() as Node
	add_child(options_instance)
	options_instance.back_pressed.connect(_on_options_closed.bind(options_instance))
	
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
	
func _on_options_closed(options_instance: Node) -> void:
	options_instance.queue_free()
