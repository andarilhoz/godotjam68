extends Node

@export var music : AudioStream = preload("res://Audio/forge-194549.mp3")

# Load sound effects
@export var discard_sound : AudioStream = preload("res://Audio/sfx/discard.wav")
@export var forge_machine : AudioStream = preload("res://Audio/sfx/forging machine_loop.wav")
@export var take_iron : AudioStream = preload("res://Audio/sfx/take iron.wav")
@export var take_weapon : AudioStream = preload("res://Audio/sfx/take weapon from forge.wav")
@export var take_wood : AudioStream = preload("res://Audio/sfx/take wood.wav")
@export var deliver_weapon : AudioStream = preload("res://Audio/sfx/weapon deliver.wav")
@export var footstep_sound : AudioStream = preload("res://Audio/sfx/footstep_loop.wav")

# Instance variables for AudioStreamPlayers
var music_player : AudioStreamPlayer
var sfx_discard_player : AudioStreamPlayer
var sfx_forge_machine_player : AudioStreamPlayer
var sfx_take_iron_player : AudioStreamPlayer
var sfx_take_weapon_player : AudioStreamPlayer
var sfx_take_wood_player : AudioStreamPlayer
var sfx_deliver_weapon_player : AudioStreamPlayer
var sfx_footstep_player : AudioStreamPlayer

var muted : bool = false

func _ready():
	# Setup buses (create and name buses)
	setup_audio_buses()

	# Load settings and configure volumes or muting
	load_and_apply_audio_settings()
	
	# Initialize and configure audio players for different sound effects
	music_player = create_audio_player("MusicPlayer", true)
	music_player.stream = music
	music_player.autoplay = true
	music_player.play()
	
	sfx_discard_player = create_audio_player("SFXDiscard")
	sfx_forge_machine_player = create_audio_player("SFXForgeMachine")
	sfx_take_iron_player = create_audio_player("SFXTakeIron")
	sfx_take_weapon_player = create_audio_player("SFXTakeWeapon")
	sfx_take_wood_player = create_audio_player("SFXTakeWood")
	sfx_deliver_weapon_player = create_audio_player("SFXDeliverWeapon")
	sfx_footstep_player = create_audio_player("SFXFootstep")

# Helper function to create and return a configured AudioStreamPlayer
func create_audio_player(name: String, is_music: bool = false) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.name = name
	if is_music:
		player.bus = AudioServer.get_bus_name(1)# Assign the music player to the Music bus
	else:
		player.bus = AudioServer.get_bus_name(2)#    # Assign all SFX players to the SFX bus
	add_child(player)
	return player

# Helper function to setup audio buses
func setup_audio_buses():
	AudioServer.set_bus_name(0, "Master")
	AudioServer.set_bus_name(1, "Music")
	AudioServer.set_bus_name(2, "SFX")

# Helper function to load and apply audio settings
func load_and_apply_audio_settings():
	var audio_settings = ConfigFileHandler.load_audio_settings()
	muted = audio_settings["master_volume_mute"]
	AudioServer.set_bus_mute(0, audio_settings["master_volume_mute"])
	AudioServer.set_bus_mute(1, audio_settings["music_volume_mute"])
	AudioServer.set_bus_mute(2, audio_settings["sfx_volume_mute"])
	
	print("config: ", audio_settings["music_volume_mute"])
	
	AudioServer.set_bus_volume_db(0, linear_to_decibels(audio_settings["master_volume"]))
	AudioServer.set_bus_volume_db(1, linear_to_decibels(audio_settings["music_volume"]))
	AudioServer.set_bus_volume_db(2, linear_to_decibels(audio_settings["sfx_volume"]))

func linear_to_decibels(linear_volume: float) -> float:
	if linear_volume == 0:
		return -80 # Treat 0 as silence in Godot, typically -80 dB
	else:
		return 20 * log(linear_volume) / log(10)

func _on_ToggleSound_pressed():
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
	ConfigFileHandler.save_audio_settings("master_volume_mute", AudioServer.is_bus_mute(0))

# Functions to play various sounds using dedicated players
func play_discard():
	sfx_discard_player.stream = discard_sound
	sfx_discard_player.play()

func play_forge_machine():
	sfx_forge_machine_player.stream = forge_machine
	sfx_forge_machine_player.play()

func play_take_iron():
	sfx_take_iron_player.stream = take_iron
	sfx_take_iron_player.pitch_scale = randf_range(0.8, 1.2)
	sfx_take_iron_player.play()

func play_take_weapon():
	sfx_take_weapon_player.stream = take_weapon
	sfx_take_weapon_player.pitch_scale = randf_range(0.8, 1.2)
	sfx_take_weapon_player.play()

func play_take_wood():
	sfx_take_wood_player.stream = take_wood
	sfx_take_wood_player.pitch_scale = randf_range(0.8, 1.2)
	sfx_take_wood_player.play()

func play_deliver_weapon():
	sfx_deliver_weapon_player.stream = deliver_weapon
	sfx_deliver_weapon_player.play()

func play_footstep():
	sfx_footstep_player.stream = footstep_sound
	sfx_footstep_player.pitch_scale = randf_range(0.4, 0.7)
	sfx_footstep_player.play()
