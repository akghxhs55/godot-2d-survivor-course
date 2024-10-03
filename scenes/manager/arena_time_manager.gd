extends Node

signal arena_difficulty_increased(arena_difficulty: int)

@export var end_screen_scene: PackedScene = null

@onready var timer: Timer = $Timer

const DIFFICULTY_INTERVAL: int = 5

var arena_difficulty: int = 0
var previous_time: float = 0


func _ready() -> void:
	previous_time = timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	
	
func _process(delta: float) -> void:
	var next_time_target: float = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)
	

func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left
	
	
func _on_timer_timeout() -> void:
	var victory_screen: CanvasLayer = end_screen_scene.instantiate() as CanvasLayer
	add_child(victory_screen)
	victory_screen.set_victory()
