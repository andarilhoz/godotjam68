extends Control

@onready var volume_btn : Button = $MarginContainer/VBoxContainer/Volume
@onready var master_slide: HSlider = $"Control/VBoxContainer/Panel - Audio/Slider - Master Volume"
@onready var music_slide: HSlider = $"Control/VBoxContainer/Panel - Audio/Slider - Music Volume"
@onready var sfx_slide: HSlider = $"Control/VBoxContainer/Panel - Audio/Slider - SFX Volume"

@onready var full_screen: CheckButton = $"Control/VBoxContainer/Panel - Video/FullScreenBtn"
@onready var camera_shake: CheckButton = $"Control/VBoxContainer/Panel - Video/CameraShakeBtn"

func _ready():
	var audio_settings = ConfigFileHandler.load_audio_settings()
	var video_settings = ConfigFileHandler.load_video_settings()
	master_slide.value = audio_settings["master_volume"] * 100
	music_slide.value = audio_settings["music_volume"] * 100
	sfx_slide.value = audio_settings["sfx_volume"] * 100
	full_screen.grab_focus()
	print("fullscreen value: ", video_settings["fullscreen"])
	full_screen.button_pressed = video_settings["fullscreen"]
	camera_shake.button_pressed = video_settings["screen_shake"]

func _process(delta):
	if Input.is_action_just_pressed("ui_go_back"):
		_on_back_pressed()

func _on_back_pressed():
	SceneTransition.change_scene_to_file("res://menu/menu.tscn")

func _on_slider__master_volume_value_changed(value):
	ConfigFileHandler.save_audio_settings("master_volume",value/100)

func _on_slider__sfx_volume_value_changed(value):
	ConfigFileHandler.save_audio_settings("sfx_volume",value/100)

func _on_slider__music_volume_value_changed(value):
	ConfigFileHandler.save_audio_settings("music_volume",value/100)


func _on_full_screen_btn_toggled(toggled_on):
	ConfigFileHandler.save_video_settings("fullscreen", toggled_on)
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		return
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	


func _on_camera_shake_btn_toggled(toggled_on):
	ConfigFileHandler.save_video_settings("screen_shake", toggled_on)
