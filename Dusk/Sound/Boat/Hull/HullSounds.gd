extends Node3D

@onready
var collision_sound_resource : Array = [preload("res://Sound/Boat/Hull/hull_hit_1.wav"), preload("res://Sound/Boat/Hull/hull_hit_2.wav"), preload("res://Sound/Boat/Hull/hull_hit_3.wav")]

func collision(collision_position : Vector3, velocity : float):
	if ($HitSound.playing or velocity < 1):
		return
	
	var sound_resource = collision_sound_resource[randi_range(0, 2)]
	$HitSound.stream = sound_resource
	$HitSound.global_position = collision_position
	$HitSound.play()
	

func set_muffled(state : bool):
	if (state):
		$HullAmbiance.bus = "Muffle"
		$HitSound.bus = "Muffle"
	else:
		$HullAmbiance.bus = "Environment"
		$HitSound.bus = "Environment"
