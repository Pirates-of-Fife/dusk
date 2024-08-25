extends Node3D

@onready
var ambiant_sound_player : AmbientSoundPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	ambiant_sound_player = get_parent_node_3d().get_parent_node_3d().get_node("AmbientSound")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	ambiant_sound_player.set_muffled(true)


func _on_area_3d_body_exited(body):
	ambiant_sound_player.set_muffled(false)
