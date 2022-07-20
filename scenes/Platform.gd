extends Node2D

enum PLATFORM_MOVEMENT {
	SIDE_TO_SIDE,
	TOP_BOTTOM
}

export (PLATFORM_MOVEMENT) var move_type


func _ready() -> void:
	var anim_name = PLATFORM_MOVEMENT.keys()[move_type]
	$AnimationPlayer.play(anim_name.to_lower())
