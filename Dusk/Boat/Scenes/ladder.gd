extends Node3D

signal player_used_ladder

func _on_interactable_interact():
	player_used_ladder.emit()
