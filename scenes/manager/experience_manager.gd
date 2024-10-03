extends Node

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH: float = 5.0

var _current_experience: float = 0.0
var _target_experience: float = 5.0
var current_level: int = 1


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(_on_experience_vial_collected)


func _increment_experience(number: float) -> void:
	_current_experience = min(_current_experience + number, _target_experience)
	experience_updated.emit(_current_experience, _target_experience)
	if _current_experience == _target_experience:
		current_level += 1
		_target_experience += TARGET_EXPERIENCE_GROWTH
		_current_experience = 0
		experience_updated.emit(_current_experience, _target_experience)
		level_up.emit(current_level)
	
	
func _on_experience_vial_collected(number: float) -> void:
	_increment_experience(number)
