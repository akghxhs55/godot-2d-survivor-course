extends CharacterBody2D

const MAX_SPEED: int = 150
const ACCELERATION_SMOOTHING: int = 20

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities

var _number_colliding_bodies: int = 0


func _ready() -> void:
	$CollisionArea2D.body_entered.connect(_on_body_entered)
	$CollisionArea2D.body_exited.connect(_on_body_exited)
	damage_interval_timer.timeout.connect(_on_damage_interval_timer_timeout)
	health_component.health_changed.connect(_on_health_changed)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)
	_update_health_display()
	
	
func _process(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector()
	var direction: Vector2 = movement_vector.normalized()
	
	var target_velocity: Vector2 = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	

func get_movement_vector() -> Vector2:
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)
	
	
func _check_deal_damage() -> void:
	if _number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func _update_health_display() -> void:
	health_bar.value = health_component.get_health_percent()


func _on_body_entered(other_body: Node2D) -> void:
	_number_colliding_bodies += 1
	_check_deal_damage()
	
	
func _on_body_exited(other_body: Node2D) -> void:
	_number_colliding_bodies -= 1
	
	
func _on_damage_interval_timer_timeout() -> void:
	_check_deal_damage()
	
	
func _on_health_changed() -> void:
	_update_health_display()
	
	
func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if not upgrade is Ability:
		return
		
	var ability: Ability = upgrade as Ability
	abilities.add_child(ability.ability_controller_scene.instantiate())
