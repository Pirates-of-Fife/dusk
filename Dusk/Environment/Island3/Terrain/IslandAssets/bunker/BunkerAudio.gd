extends Node3D

@export
var start_distance : float

@export
var distance_where_music_is_at_max_loudness : float

@export
var min_volume_db : float

@export
var max_volume_db : float

var player : Node3D

var distance_to_player : float

@onready
var audio_bus_pitch : AudioEffectPitchShift = AudioServer.get_bus_effect(5, 1)

@onready
var audio_bus_reverb : AudioEffectReverb = AudioServer.get_bus_effect(5, 0)

func _ready():
	player = get_parent_node_3d().get_parent_node_3d().get_node("Player")

func _process(delta):
	distance_to_player = (global_position - player.global_position).length()
	
	if (distance_to_player < start_distance):
		if (!$DuskMusic.playing):
			$DuskMusic.play()
	else:
		$DuskMusic.stop()
	
	set_volume($DuskMusic, distance_to_player, start_distance, distance_where_music_is_at_max_loudness)

	
func set_volume(player : AudioStreamPlayer, distance : float, min_distance : float, max_distance : float) -> void:
	var distance_normalized : float = (distance - min_distance) / (max_distance - min_distance)
	
	distance_normalized = clampf(distance_normalized, 0, 1)
	
	player.volume_db = lerpf(min_volume_db, max_volume_db, distance_normalized)
	audio_bus_pitch.pitch_scale = lerpf(0.5, 1, distance_normalized)


func _on_interactable_interact():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().change_scene_to_file("res://UI/Credits/CreditScreen.tscn")
