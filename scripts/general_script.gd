extends Node2D

@onready var toggle_sound: TextureButton = $InGame_CanvasLayer/ToggleSound

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

func _ready():
	$InGame_CanvasLayer.visible = true
	toggle_sound.button_pressed = SoundControl.muted
