extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_interact():
	var heading = normalize_angle(360 - int(round(get_parent_node_3d().value)))

	print(heading)
	
	var text = "Heading to " + str(heading) + "°. Facing " + getDirection(heading) + "."
	
	$TextDisplay.show_text(text)

# Function to determine direction based on angle
func getDirection(angle: float) -> String:
	if angle < 0:
		angle += 360  # Convert negative angles to positive

	if (angle >= 337.5 or angle < 22.5):
		return "North"
	elif angle < 67.5:
		return "Northeast"
	elif angle < 112.5:
		return "East"
	elif angle < 157.5:
		return "Southeast"
	elif angle < 202.5:
		return "South"
	elif angle < 247.5:
		return "Southwest"
	elif angle < 292.5:
		return "West"
	else:
		return "Northwest"

func normalize_angle(angle):
	# Ensure the angle is within 0° to 360°
	angle = angle % 360
	if angle < 0:
		angle += 360
	return angle
