extends Node3D

@onready
var player : Node3D

@export
var visibility_range : float = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent_node_3d().get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance_to_player = (global_position - player.global_position).length()
	
	if (distance_to_player < visibility_range):
		if (!visible):
			show()
	else:
		if (visible):
			hide()
