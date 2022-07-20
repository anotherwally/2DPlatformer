extends KinematicBody2D

var gravity := 2200
var velocity := Vector2()

var UP_DIR = Vector2.UP

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, UP_DIR)
