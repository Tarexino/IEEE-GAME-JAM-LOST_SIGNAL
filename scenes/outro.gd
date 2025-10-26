extends Node2D

@onready var text_panel = $Node2D
@onready var animation_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("outro_transition")
	$Button.hide()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
