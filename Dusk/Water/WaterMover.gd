extends Node3D

@onready
var player : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	if (get_parent_node_3d().has_node("Player")):
		player = get_parent_node_3d().get_node("Player")
	else:
		player = get_parent_node_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Water.global_position.x = player.global_position.x
	$Water.global_position.z = player.global_position.z

