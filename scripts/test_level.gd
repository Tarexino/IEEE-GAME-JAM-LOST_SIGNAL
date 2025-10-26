extends Node2D

@onready var distortion_bar = $CanvasLayer/UI/DistortionBar
@onready var player = $Player
@onready var pause_menu = $CanvasLayer/PauseMenu

@onready var radar_cooldown_bar = $CanvasLayer/UI/CooldownContainer/RadarBarContainer/RadarCooldownBar
@onready var radar_cooldown_bar_label = $CanvasLayer/UI/CooldownContainer/RadarBarContainer/RadarCooldownBar/Label2
@onready var absorbed_progress_bar = $CanvasLayer/UI/CooldownContainer/AbsorptionBarContainer/AbsorptionCapacity
@onready var absorbed_label = $CanvasLayer/UI/CooldownContainer/AbsorptionBarContainer/AbsorptionCapacity/Label2
@onready var signal_emitter_manager = $SignalEmitterManager
@onready var signal_repaired_count_label = $CanvasLayer/UI/SignalRepairCounterContainer/HBoxContainer/SignalRepairCountLabel
@onready var audio_player = $AudioStreamPlayer
@onready var switch = $Switch
@onready var laser = $ProjectileEmitterManager/LASERBRRRRR
@onready var message = $CanvasLayer/UI/Message
@onready var final_tile_map_layer = $TileMapFinalRoom
@onready var obstacle = $Obstacle


var repaired_signals_list : Array[SignalParticle] = []
var total_signals_count : int
var game_over_screen = preload("res://scenes/game_over_screen.tscn")
var horror_song = preload("res://assets/sound/8-bit-horror-noises-63944.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_signals_count = len(signal_emitter_manager.get_children())
	audio_player.play()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		pause()


func pause():
	get_tree().paused = true
	pause_menu.show()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if len(repaired_signals_list) >= 6:
		$TileMapLayer2.show()
		
	for emitter in signal_emitter_manager.get_children():
		if emitter.is_repaired and emitter not in repaired_signals_list:
			repaired_signals_list.append(emitter)
	signal_repaired_count_label.text = str(len(repaired_signals_list)) + "/" + str(total_signals_count)
	
	distortion_bar.max_value = player.distortion_limit
	distortion_bar.value = player.distortion
	
	
	if distortion_bar.value >= distortion_bar.max_value:
		Global.absorbed_projectiles = 0
		get_tree().change_scene_to_packed(game_over_screen)
	radar_cooldown_bar.max_value = player.cooldown_timer.wait_time
	radar_cooldown_bar.value = player.cooldown_timer.wait_time - player.cooldown_timer.time_left
	
	if radar_cooldown_bar.value < radar_cooldown_bar.max_value:
		radar_cooldown_bar_label.text = ""
	else:
		radar_cooldown_bar_label.text = "Ready!"
		
	absorbed_progress_bar.value = player.absorbed_projectile_count
	absorbed_label.text = str(absorbed_progress_bar.value) + "/" + str(absorbed_progress_bar.max_value)
	
	if absorbed_progress_bar.value > absorbed_progress_bar.max_value:
		player.dmg_multiplier = 1.0


func _on_switch_switch_turned_off() -> void:
	laser.stop_emission()
	message.text = "Laser disabled. Final room accessible"


func _on_main_door_switch_main_door_switch_turned_on() -> void:
	if len(repaired_signals_list) == total_signals_count:
		obstacle.position.x += 100
		final_tile_map_layer.show()
		message.text = "Final room now opened. Please walk to the room"


func _on_final_area_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/outro.tscn")
