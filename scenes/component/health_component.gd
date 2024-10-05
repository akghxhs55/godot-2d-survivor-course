extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 10
var _current_health: float


func _ready() -> void:
	_current_health = max_health


func damage(damage_amount: float) -> void:
	_current_health	= max(_current_health - damage_amount, 0)
	print(_current_health)
	health_changed.emit()
	Callable(_check_death).call_deferred()
	

func get_health_percent() -> float:
	if max_health <= 0:
		return 0
	return minf(_current_health / max_health, 1.0)


func _check_death() -> void:
	if _current_health == 0:
		died.emit()
		owner.queue_free()
	
