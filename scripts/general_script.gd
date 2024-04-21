extends Node2D

@onready var toggle_sound: TextureButton = $InGame_CanvasLayer/ToggleSound
@onready var pause_panel = $InGame_CanvasLayer/PausePanel


func _process(delta):
	if Input.is_action_just_pressed("ui_select_pause"):
		pause_panel.pause_game()

func _ready():
	$InGame_CanvasLayer.visible = true
	SoundControl.play_game_music()
	toggle_sound.button_pressed = SoundControl.muted
