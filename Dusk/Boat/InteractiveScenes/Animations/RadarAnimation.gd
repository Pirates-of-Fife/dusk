extends Node3D

var radar_on : bool = false
var current_speed : float = 0.0
var max_speed : float = 0.1 # The fixed speed at which the radar will spin
var acceleration : float = 0.05 # How quickly the radar speeds up to its max speed
var deceleration : float = 0.05 # How quickly the radar slows down when turned off

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Initial setup can be placed here if necessary.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if radar_on:
		# Accelerate the radar until it reaches its maximum speed.
		if current_speed < max_speed:
			current_speed += acceleration * delta
			if current_speed > max_speed:
				current_speed = max_speed
	else:
		# Decelerate the radar until it stops.
		if current_speed > 0:
			current_speed -= deceleration * delta
			if current_speed < 0:
				current_speed = 0.0
	
	# Apply the current speed to the radar's rotation.
	$Radar.rotation.y += current_speed
	
	if $Radar.rotation.y > 360:
		$Radar.rotation.y -= 360 # Keep the rotation value manageable.
