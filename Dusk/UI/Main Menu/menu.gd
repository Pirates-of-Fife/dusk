extends Control

@export
var game_scene : String

@export
var IntroAnimations : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	IntroAnimations.play("PlayAnimation")

func _on_quit_pressed():
	get_tree().quit()


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://UI/Credits/CreditScreen.tscn")


func _on_intro_animations_animation_finished(anim_name):
	if (anim_name == "PlayAnimation"):
		get_tree().change_scene_to_file(game_scene)
