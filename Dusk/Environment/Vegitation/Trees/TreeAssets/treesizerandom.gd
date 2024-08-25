extends Node3D
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hole die aktuelle Größe des Baums
	var current_scale = get_scale()
	
	var random_factor =rng.randf_range(-0.1, 0.1)
	
	var new_scale = current_scale * (1 + random_factor)
	
	set_scale(new_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
