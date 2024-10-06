extends CharacterBody2D

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var velocity_component: Node = $VelocityComponent

var _number_colliding_bodies: int = 0
var base_speed: float = 0.0


func _ready() -> void:
	base_speed = velocity_component.max_speed
	
	$CollisionArea2D.body_entered.connect(_on_body_entered)
	$CollisionArea2D.body_exited.connect(_on_body_exited)
	damage_interval_timer.timeout.connect(_on_damage_interval_timer_timeout)
	health_component.health_changed.connect(_on_health_changed)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)
	_update_health_display()
	
	
func _process(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector()
	var direction: Vector2 = movement_vector.normalized()
	
	velocity_component.accelerate_in_direction(direction, delta)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale.x = move_sign
	

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
	GameEvents.emit_player_damaged()
	_update_health_display()
	$HitRandomStreamPlayer.play_random()
	
	
func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade is Ability:
		var ability: Ability = upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	
	if upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.1)
