extends Node3D

@export_category("Wheel")

@export_range(-1, 1, 0.1)
var wheel_turn : float

@export
var wheel : Node3D


@export_category("Throttle")

@export_range(-1, 1, 0.1)
var throttle : float

@export
var throttle_node : Node3D

@export_category("Rudder and Props")

@export
var rudder_and_props : Node3D

@export_category("Speed")

@export
var speed : float

@export
var speed_gauge : Node3D

@export_category("RPM")

@export
var rpm : float

@export
var rpm_gauge : Node3D

@export_category("Fuel")

@export
var fuel : float

@export
var fuel_gauge : Node3D

@export_category("Compass")

@export
var compass : Node3D

var heading : float

var clutch_on : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	wheel.wheel_rotation = wheel_turn
	throttle_node.throttle = throttle
	
	rudder_and_props.turn = wheel_turn
	
	if (!clutch_on):
		rudder_and_props.engine_rpm = rpm
	else:
		rudder_and_props.engine_rpm = 0
	
	speed_gauge.value = speed
	rpm_gauge.value = rpm
	fuel_gauge.value = fuel
	
	compass.value = heading
