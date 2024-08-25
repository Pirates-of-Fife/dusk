extends Node3D

var engine_rpm : float = 0

var turn : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Propeller.rotation.z += deg_to_rad(engine_rpm / 60 / 4)
	
	if $Propeller.rotation.z > 360:
		$Propeller.rotation.z -= 360
		
	$Propeller_001.rotation.z += deg_to_rad(engine_rpm / 60 / 4)
	
	if $Propeller_001.rotation.z > 360:
		$Propeller_001.rotation.z -= 360
		
	$Rudder.rotation.y = deg_to_rad(45 * turn)
	$Rudder_001.rotation.y = deg_to_rad(45 * turn)
