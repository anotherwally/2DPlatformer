extends Position2D

var grid_size := Vector2()
var grid_position := Vector2()

onready var parent := get_parent()

func _ready() -> void:
	# Maybe use get_viewport?
	grid_size = get_viewport().size
	set_as_toplevel(true)
	_update_grid_position()


func _physics_process(_delta: float) -> void:
	_update_grid_position()


func _update_grid_position() -> void:
	var x = round(parent.position.x / grid_size.x)
	var y = round(parent.position.y / grid_size.y)
	var new_grid_position = Vector2(x, y)
	
	if grid_position == new_grid_position:
		return
	
	grid_position = new_grid_position
	position = grid_position * grid_size
