extends Node

@onready var music_bus = AudioServer.get_bus_index("Music")

var muted : bool = false

func _ready():
	muted = ConfigFileHandler.load_audio_settings()["master_volume_mute"]
	AudioServer.set_bus_mute(music_bus, muted)

func _on_ToggleSound_pressed():
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
	ConfigFileHandler.save_audio_seeting("master_volume_mute", not muted)
