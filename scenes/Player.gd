extends KinematicBody2D

export var SPEED := 300
export var JUMP_SPEED := -600
export var GRAVITY := 2200

const UP_DIR = Vector2.UP

var velocity = Vector2()
var prev_velocity = Vector2()
var ground_hit = false
var direction

onready var sprite := $Sprite
onready var animation := $AnimationPlayer
onready var ray := $RayCast2D

func _get_input() -> void:
	direction = (Input.get_action_strength("right") - Input.get_action_strength("left"))
	velocity.x = direction * SPEED
	
	if _is_jumping():
		velocity.y = JUMP_SPEED
	elif _is_jump_cancelled():
		velocity.y = lerp(velocity.y, 0.0, 0.75)


func _stretch() -> void:
	if !is_on_floor():
		ground_hit = false
		sprite.scale.y = range_lerp(abs(velocity.y), 0, abs(JUMP_SPEED), 0.75, 1.75)
		sprite.scale.x = range_lerp(abs(velocity.y), 0, abs(JUMP_SPEED), 1.25, 0.75)


func _squash() -> void:
	if !ground_hit && is_on_floor():
		ground_hit = true
		sprite.scale.y = range_lerp(abs(prev_velocity.y), 0, abs(1700), 1.2, 2.0)
		sprite.scale.x = range_lerp(abs(prev_velocity.y), 0, abs(1700), 0.8, 0.5)


func _revert_sprite_scale(delta: float) -> void:
	# a = lerp(a, b, 1 - pow(f, dt))
	sprite.scale.y = lerp(sprite.scale.y, 1, 1 - pow(0.0001, delta))
	sprite.scale.x = lerp(sprite.scale.x, 1, 1 - pow(0.0001, delta))


func _is_jumping() -> bool:
	return Input.is_action_just_pressed("jump") && is_on_floor()


func _is_jump_cancelled() -> bool:
	return Input.is_action_just_released("jump") && velocity.y < 0.0


func _is_running() -> bool:
	return is_on_floor() && !is_zero_approx(direction) && !is_on_wall()


func _is_falling() -> bool:
	return velocity.y > 0.0 && !is_on_floor()


func _is_idle() -> bool:
	return is_on_floor() && is_zero_approx(direction)


func _play_animation() -> void:
	if _is_jumping() || _is_falling():
		animation.play("jump")
	elif _is_running():
		animation.play("walk")
	elif _is_idle():
		animation.play("idle")


func _update_look_direction() -> void:
	if !is_zero_approx(direction):
		if direction == 1:
			sprite.flip_h = true
		elif direction == -1:
			sprite.flip_h = false


func _stomp() -> void:
	if ray.is_colliding():
		for idx in get_slide_count():
			var collision := get_slide_collision(idx)
			
			if collision.collider.is_in_group("enemies"):
				print_debug("ENEMY!")


func _physics_process(delta: float) -> void:
	_get_input()
	_play_animation()
	_update_look_direction()
	_squash()
	_stretch()
	_revert_sprite_scale(delta)
	_stomp()
	
	velocity.y += GRAVITY * delta
	prev_velocity = velocity
	velocity = move_and_slide(velocity, UP_DIR)
