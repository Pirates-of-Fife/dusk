extends Node3D

@export
var value : float = 0

@export
var min_value : float = 0

@export
var max_value : float = 100

@export
var zero_y_rotation : float = 240

@export
var full_y_rotation : float = -50

@onready
var pointer : Node3D = $Gauge/GaugePointer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var normalized_value = (value - min_value) / (max_value - min_value)
	var rotation = zero_y_rotation + normalized_value * (full_y_rotation - zero_y_rotation)

	pointer.rotation.y = deg_to_rad(rotation)
