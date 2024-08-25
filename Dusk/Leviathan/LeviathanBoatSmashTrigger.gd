extends Node3D

var has_hit : bool = false

func _on_area_3d_body_entered(body):
	if (body == get_parent_node_3d().get_node("Player")):
		if has_hit == true:
			return
		
		get_parent_node_3d().get_node("Boat").leviathan_collision()
		
		has_hit = true
