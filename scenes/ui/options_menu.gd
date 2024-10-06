extends CanvasLayer

signal back_pressed

@onready var window_button: Button = $%WindowButton
@onready var sfx_slider: HSlider = $%SfxSlider
@onready var music_slider: HSlider = $%MusicSlider
@onready var back_button: Button = $%BackButton


func _ready() -> void:
	window_button.pressed.connect(_on_window_button_pressed)
	sfx_slider.value_changed.connect(_on_audio_slider_changed.bind("SFX"))
	music_slider.value_changed.connect(_on_audio_slider_changed.bind( "Music"))
	back_button.pressed.connect(_on_back_button_pressed)
	
	_update_display()
	

func _on_window_button_pressed() -> void:
	var mode: int = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	_update_display()
	

func _on_audio_slider_changed(value: float, bus_name: String) -> void:
	_set_bus_volume_percent(bus_name, value)

	
func _on_back_button_pressed() -> void:
	back_pressed.emit()

	
func _update_display() -> void:
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	sfx_slider.value = _get_bus_volume_percent("SFX")
	music_slider.value = _get_bus_volume_percent("Music")
		
		
func _get_bus_volume_percent(bus_name: String) -> float:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func _set_bus_volume_percent(bus_name: String, percent: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
