extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_key_pressed(KEY_T)):
		$AnimationController.wheel_turn = 1
		$AnimationController.throttle = 1
		$ShipHull/Mesh/Interior/button.on_press()
		$ShipHull/Mesh/cabin/door.use_door()
		
		$ShipHull/Mesh/Hull/propeller_rudder.engine_rpm += 100
		
		$ShipHull/Mesh/cabin/radar.radar_on = true
		
	else:
		$AnimationController.wheel_turn = 0
		$AnimationController.throttle = -1

	if (Input.is_key_pressed(KEY_R)):
		$ShipHull/Mesh/cabin/radar.radar_on = false

	if (Input.is_key_pressed(KEY_A)):
		$ShipHull/Mesh/Hull/propeller_rudder.turn = 1
	elif (Input.is_key_pressed(KEY_D)):
		$ShipHull/Mesh/Hull/propeller_rudder.turn = -1
	else:
		$ShipHull/Mesh/Hull/propeller_rudder.turn = 0
