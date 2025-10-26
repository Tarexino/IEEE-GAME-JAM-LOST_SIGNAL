extends Node2D

@onready var distortion_bar = $CanvasLayer/UI/DistortionBar
@onready var player = $Player
@onready var pause_menu = $CanvasLayer/PauseMenu

@onready var radar_cooldown_bar = $CanvasLayer/UI/CooldownContainer/RadarBarContainer/RadarCooldownBar
@onready var radar_cooldown_bar_label = $CanvasLayer/UI/CooldownContainer/RadarBarContainer/RadarCooldownBar/Label2
@onready var absorbed_progress_bar = $CanvasLayer/UI/CooldownContainer/AbsorptionBarContainer/AbsorptionCapacity
@onready var absorbed_label = $CanvasLayer/UI/CooldownContainer/AbsorptionBarContainer/AbsorptionCapacity/Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		pause()


func pause():
	get_tree().paused = true
	pause_menu.show()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	distortion_bar.max_value = player.distortion_limit
	distortion_bar.value = player.distortion
	radar_cooldown_bar.max_value = player.cooldown_timer.wait_time
	radar_cooldown_bar.value = player.cooldown_timer.wait_time - player.cooldown_timer.time_left
	
	if radar_cooldown_bar.value < radar_cooldown_bar.max_value:
		radar_cooldown_bar_label.text = ""
	else:
		radar_cooldown_bar_label.text = "Ready!"
		
	absorbed_progress_bar.value = player.absorbed_projectile_count
	absorbed_label.text = "%d/%d" % [absorbed_progress_bar.value, absorbed_progress_bar.max_value]
