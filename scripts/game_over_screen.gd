extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_level.tscn")

func _ready() -> void:
	$AudioStreamPlayer.play(0.5)
