extends Node2D

@onready var toggle_sound: TextureButton = $InGame_CanvasLayer/ToggleSound
@onready var pause_panel = $InGame_CanvasLayer/PausePanel

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			pause_panel.pause_game()

func _ready():
	$InGame_CanvasLayer.visible = true
	SoundControl.play_game_music()
	toggle_sound.button_pressed = SoundControl.muted
