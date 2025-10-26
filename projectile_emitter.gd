extends Node2D
class_name ProjectileEmitter

@onready var timer = $Timer
@onready var audio_player = $AudioStreamPlayer2D

@export var direction : Vector2 = Vector2(1, 0)
@export var fire_interval : float = 1.0

var projectile_scene = preload("res://scenes/projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = direction.normalized()
	timer.wait_time = fire_interval


func emit_projectile():
	var projectile_instance = projectile_scene.instantiate()
	add_child(projectile_instance)
	projectile_instance.position = Vector2.ZERO
	projectile_instance.direction_vector = direction
	audio_player.play()


func _on_timer_timeout() -> void:
	emit_projectile()

func stop_emission():
	timer.stop()
