extends CanvasLayer


func _ready() -> void:
	GameEvents.player_damaged.connect(_on_player_damaged)
	

func _on_player_damaged() -> void:
	$AnimationPlayer.play("hit")
	