extends Control

@onready var control_page = $ControlsPage
@onready var main_page = $Main


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()
	

func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_controls_button_pressed() -> void:
	control_page.show()
	main_page.hide()


func _on_back_button_pressed() -> void:
	control_page.hide()
	main_page.show()
