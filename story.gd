extends Node2D


@onready var animation_player = $AnimationPlayer
@onready var animation_player_sprite = $PlayerAnimationPlayer
@onready var node = $Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	node.show()
	animation_player.play("scroll")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animation_player_sprite.play("Play")

func stop_player():
	animation_player_sprite.stop()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_level.tscn")
	
func hide_rect():
	$Control/ColorRect.hide()
	
