extends Area2D
class_name Projectile

@export var velocity : float = 40.0
@export var damage : float = 20
var direction_vector : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction_vector * velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.is_absorbing:
			Global.absorbed_projectiles += 1
			body.take_damage_during_absorption(damage)
			queue_free()
		else:
			body.take_damage(damage)
			queue_free()
