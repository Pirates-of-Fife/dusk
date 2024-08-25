extends SpotLight3D

var light_on : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_light_button_button_press():
	if (light_on):
		light_energy = 0
		spot_range = 0
		light_on = false
		hide()
	else:
		light_energy = 10
		spot_range = 50
		light_on = true
		show()
