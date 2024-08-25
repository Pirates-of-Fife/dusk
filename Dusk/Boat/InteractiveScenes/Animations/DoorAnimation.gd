extends Node3D

var door_open : bool = false

@onready
var animation : AnimationPlayer = $AnimationPlayer

func use_door():
	if (animation.is_playing()):
		return
	
	if (door_open):
		animation.play("close_door")
		$OpenDoorSound.play()
		door_open = false
	else:
		animation.play("open_door")
		$CloseDoorSound.play()
		door_open = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_interact():
	use_door() # Replace with function body.
