extends Node3D

class_name MapPart

@onready
var game_manager : GameManager 

@export
var is_first_map : bool = false

func _ready():
	game_manager = get_tree().root.get_node("/root/Dusk/GameManager")

func _on_interactable_interact():
	game_manager.map_collected()
	$AudioStreamPlayer3D.play()
	$Interactable.active = false
	hide()


func _on_audio_stream_player_3d_finished():
	get_parent_node_3d().remove_child(self)


func _on_interactable_looked_at(active):
	if (is_first_map and active):
		$Label3D.show()
	else:
		$Label3D.hide()
