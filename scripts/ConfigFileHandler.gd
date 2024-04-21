extends Node

var config = ConfigFile.new()

const SETTINGS_FILE_PATH = "user://settings.ini"



func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("video", "fullscreen", true)
		config.set_value("video", "screen_shake", true)
		
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "music_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
	silent_wolf()
	if config.get_value("video", "fullscreen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		return
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func silent_wolf():
	SilentWolf.configure({
		"api_key": "L5Ws5mBksmFPFmys9N0T4FiXuwa6Jmw69IApRQDb",
		"game_id": "ThroughtheForgeandtheFlame",
		"log_level": 1
	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/MainPage.tscn"
	})

func save_video_settings(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings
	
	
func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	SoundControl.load_and_apply_audio_settings()

func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings

func save_highscore(points: int):
	config.set_value("score", "high", points)
	config.save(SETTINGS_FILE_PATH)

func get_highscore() -> int:
	var score = config.get_value("score", "high", 0)
	return int(score)

