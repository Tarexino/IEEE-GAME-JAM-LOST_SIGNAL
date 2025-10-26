extends CharacterBody2D
class_name Player

@export var speed: float = 28.0
@export var diagonal_movement: bool = true
@export var distortion_limit: float = 100.0

@export var pulse_duration: float = 3.0
@export var radar_cooldown: float = 5.0
@export var radar_charges: int = 5


@onready var animation_player = $AnimationPlayer
@onready var radar_area: Area2D = $RadarArea
@onready var pulse_duration_timer = $RadarArea/PulseDurationTimer
@onready var cooldown_timer = $RadarArea/CooldownTimer
@onready var sprite = $Sprite2D
@onready var absorb_timer = $AbsorbTimer
@onready var player_colision_shape = $CollisionShape2D
@onready var radar_radius_sprite = $RadarArea/RadarSprite2D 

var is_absorbing : = false
var radar_detections_list : Array[SignalParticle] = []
var is_radar_active: bool = false
var is_radar_pulse_active : bool = false
var distortion : int = 0
var absorbed_projectile_count : int = 0


func _ready() -> void:
	pulse_duration_timer.wait_time = pulse_duration
	cooldown_timer.wait_time = radar_cooldown


func _process(delta: float) -> void:
	if is_radar_pulse_active:
		for signal_particle in radar_detections_list:
			signal_particle.show()
	elif not is_radar_pulse_active:
		for signal_particle in radar_detections_list:
			if not signal_particle.is_repaired:
				signal_particle.hide()


func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()

	if not diagonal_movement:
		if abs(input_vector.x) > abs(input_vector.y):
			input_vector.y = 0
		else:
			input_vector.x = 0

	velocity = input_vector * speed

	if Input.is_action_just_pressed("absorb"):
		animation_player.play("absorbing")
		absorb_timer.start()
		is_absorbing = true
		
	elif velocity != Vector2.ZERO and not is_absorbing:
		animation_player.play("move")
	
		
	move_and_slide()

func _input(event):
	if event.is_action_pressed("use_radar"):
		_try_activate_radar()

func _try_activate_radar():
	if not is_radar_active:
		is_radar_active = true
		radar_charges -= 1
		is_radar_pulse_active = true
		pulse_duration_timer.start()
		cooldown_timer.start()
		radar_radius_sprite.show()

	# Optional visual/audio feedback
		print("🔵 Radar pulse activated! Charges left:", radar_charges)

func _update_radar(delta: float) -> void:
	pass




func _on_cooldown_timer_timeout() -> void:
	is_radar_active = false


func _on_radar_area_area_entered(area: Area2D) -> void:
	if area is SignalParticle:
		print("detected")
		radar_detections_list.append(area)


func _on_radar_area_area_exited(area: Area2D) -> void:
	if area is SignalParticle and area in radar_detections_list:
		print("signal left")
		radar_detections_list.erase(area)


func _on_pulse_duration_timer_timeout() -> void:
	is_radar_pulse_active = false
	radar_radius_sprite.hide()


func take_damage(damage):
	distortion += damage


func _on_absorb_timer_timeout() -> void:
	is_absorbing = false
	sprite.frame = 0
