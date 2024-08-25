extends Node3D

var has_screamed : bool = false

func _on_area_3d_body_entered(body):
	if (body == get_parent_node_3d().get_node("Player")):
		if has_screamed == true:
			return
		
		$AudioStreamPlayer3D.play()
		
		has_screamed = true
