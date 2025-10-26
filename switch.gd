extends Node2D

@onready var sprite := $Sprite2D

enum type {
	DOOR,
	LASER
}

var player_entered := false
var switched_off := false
@export var type_of_switch : type 

signal switch_turned_off
signal main_door_switch_turned_on
var player : Player 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_entered and Input.is_action_just_pressed("interact"):
		if type_of_switch == type.DOOR:
			if player.absorbed_projectile_count == 5:
				player.absorbed_projectile_count -= 5
				switched_off = true
		else:
			switched_off = true
	if switched_off:
		sprite.frame = 2
		if type_of_switch == type.LASER:
			switch_turned_off.emit()
		elif type_of_switch == type.DOOR:
			main_door_switch_turned_on.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player_entered = true
		if not switched_off:
			sprite.frame = 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		player_entered = false
		if not switched_off:
			sprite.frame = 0
