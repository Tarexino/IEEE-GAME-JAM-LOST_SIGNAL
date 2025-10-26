extends Area2D
class_name SignalParticle

@onready var sprite = $Sprite2D
@onready var progress_bar = $CanvasLayer/ProgressBar

@export var required_charges : int = 1

var is_repaired : = false
var is_interactable : = false
var obtained_charges : int


func _ready() -> void:
	progress_bar.max_value = required_charges


func _process(delta: float) -> void:
	if is_repaired:
		sprite.frame = 1
	# To check if repaired
	if sprite.frame == 2 and Input.is_action_just_pressed("ui_accept") and Global.absorbed_projectiles > 0:
		obtained_charges += 1
		Global.absorbed_projectiles -= 1
		$AudioStreamPlayer2D.play()
	if obtained_charges > (required_charges - 1):
		is_repaired = true
	progress_bar.value = obtained_charges


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body is Player and not is_repaired:
		sprite.frame = 2


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body is Player and not is_repaired:
		sprite.frame = 0
