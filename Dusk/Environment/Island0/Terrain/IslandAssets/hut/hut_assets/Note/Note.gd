extends Node3D

@export
var note_text : String

func _on_interactable_interact():
	$TextDisplay.show_text(note_text)
