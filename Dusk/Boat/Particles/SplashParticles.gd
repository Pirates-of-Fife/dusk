extends Node3D


@export
var animation_controller : Node3D

@onready
var splashes : Array = get_children()

var splash_available : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play_splash():
	splash_available = false
	
	
	var random_index = randi() % splashes.size()

	var splash_node = splashes[random_index]
	
	#print(splash_node)
		
	if !splash_node.play_animation(animation_controller.speed):
		play_splash()
		
	var delay = 60 / animation_controller.speed 
	
	await get_tree().create_timer(delay).timeout

	splash_available = true


func _process(delta):
	if animation_controller.speed > 1.5 and splash_available:
		play_splash()
	
		


