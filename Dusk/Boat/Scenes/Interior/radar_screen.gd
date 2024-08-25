extends Node3D

@export
var object_to_track : Node3D

func _process(delta):
	$RadarScreen/LabelX.text = "X: " + str(roundf(object_to_track.global_position.x))
	$RadarScreen/LabelY.text = "Y: " + str(roundf(-object_to_track.global_position.z))

