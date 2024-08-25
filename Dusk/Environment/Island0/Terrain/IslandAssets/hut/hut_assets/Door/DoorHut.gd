extends Node3D

var door_open : bool = false

@export
var animation_player : AnimationPlayer

func use_door():
	if (animation_player.is_playing()):
		return
	
	if (door_open):
		animation_player.play("CloseDoor")
		get_parent_node_3d().get_node("DoorClose").play()
		door_open = false
	else:
		animation_player.play("OpenDoor")
		get_parent_node_3d().get_node("DoorOpen").play()
		door_open = true


func _on_interactable_interact():
	use_door()


