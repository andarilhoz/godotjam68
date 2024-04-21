extends Node

@export var music : AudioStream = preload("res://Audio/forge-194549.mp3")

# Load sound effects
@export var discard_sound : AudioStream = preload("res://Audio/sfx/sfx_discard.wav")
@export var forge_machine : AudioStream = preload("res://Audio/sfx/sfx_forging machine.wav")
@export var take_iron : AudioStream = preload("res://Audio/sfx/sfx_take iron.wav")
@export var take_weapon : AudioStream = preload("res://Audio/sfx/sfx_take weapon from forge.wav")
@export var take_wood : AudioStream = preload("res://Audio/sfx/sfx_take wood.wav")
@export var deliver_weapon : AudioStream = preload("res://Audio/sfx/sfx_deliver.wav")
@export var footstep_sound : AudioStream = preload("res://Audio/sfx/sfx_step.wav")

@export var forge_hit_sound : AudioStream = preload("res://Audio/sfx/sfx_forge hit.wav")
@export var forge_miss_sound : AudioStream = preload("res://Audio/sfx/sfx_forge miss.wav")
@export var game_over_sound : AudioStream = preload("res://Audio/sfx/sfx_game over.wav")
@export var hurry_loop_sound : AudioStream = preload("res://Audio/sfx/sfx_hurry_loop.wav")
@export var masterpiece_sound : AudioStream = preload("res://Audio/sfx/sfx_masterpiece.wav")
@export var order_expired_sound : AudioStream = preload("res://Audio/sfx/sfx_order expired.wav")
@export var order_received_sound : AudioStream = preload("res://Audio/sfx/sfx_order received.wav")
@export var snort_sound : AudioStream = preload("res://Audio/sfx/sfx_snort.wav")
@export var victory_sound : AudioStream = preload("res://Audio/sfx/sfx_victory.wav")
@export var wrong_order_sound : AudioStream = preload("res://Audio/sfx/sfx_wrong order.wav")


# Instance variables for AudioStreamPlayers
var music_player : AudioStreamPlayer
var sfx_discard_player : AudioStreamPlayer
var sfx_forge_machine_player : AudioStreamPlayer
var sfx_take_iron_player : AudioStreamPlayer
var sfx_take_weapon_player : AudioStreamPlayer
var sfx_take_wood_player : AudioStreamPlayer
var sfx_deliver_weapon_player : AudioStreamPlayer
var sfx_footstep_player : AudioStreamPlayer

var sfx_forge_hit_player : AudioStreamPlayer
var sfx_forge_miss_player : AudioStreamPlayer
var sfx_game_over_player : AudioStreamPlayer
var sfx_hurry_loop_player : AudioStreamPlayer
var sfx_masterpiece_player : AudioStreamPlayer
var sfx_order_expired_player : AudioStreamPlayer
var sfx_order_received_player : AudioStreamPlayer
var sfx_snort_player : AudioStreamPlayer
var sfx_victory_player : AudioStreamPlayer
var sfx_wrong_order_player : AudioStreamPlayer

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
	
	sfx_forge_hit_player = create_audio_player("SFXForgeHit")
	sfx_forge_miss_player = create_audio_player("SFXForgeMiss")
	sfx_game_over_player = create_audio_player("SFXGameOver")
	sfx_hurry_loop_player = create_audio_player("SFXHurryLoop")
	sfx_masterpiece_player = create_audio_player("SFXMasterpiece")
	sfx_order_expired_player = create_audio_player("SFXOrderExpired")
	sfx_order_received_player = create_audio_player("SFXOrderReceived")
	sfx_snort_player = create_audio_player("SFXSnort")
	sfx_victory_player = create_audio_player("SFXVictory")
	sfx_wrong_order_player = create_audio_player("SFXWrongOrder")

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
	AudioServer.set_bus_volume_db(0, linear_to_decibels(audio_settings["master_volume"]))
	AudioServer.set_bus_volume_db(1, linear_to_decibels(audio_settings["music_volume"]))
	AudioServer.set_bus_volume_db(2, linear_to_decibels(audio_settings["sfx_volume"]))

func linear_to_decibels(linear_volume: float) -> float:
	if linear_volume == 0:
		return -80 # Treat 0 as silence in Godot, typically -80 dB
	else:
		return 20 * log(linear_volume) / log(10)

func _on_ToggleSound_pressed():
	AudioServer.set_bus_volume_db(0, linear_to_decibels(0))

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
	sfx_footstep_player.pitch_scale = randf_range(0.8, 1.2)
	sfx_footstep_player.play()

func play_forge_hit():
	sfx_forge_hit_player.stream = forge_hit_sound
	sfx_forge_hit_player.play()

func play_forge_miss():
	sfx_forge_miss_player.stream = forge_miss_sound
	sfx_forge_miss_player.play()

func play_game_over():
	sfx_game_over_player.stream = game_over_sound
	sfx_game_over_player.play()

func play_hurry_loop():
	sfx_hurry_loop_player.stream = hurry_loop_sound
	sfx_hurry_loop_player.play()

func play_masterpiece():
	sfx_masterpiece_player.stream = masterpiece_sound
	sfx_masterpiece_player.play()

func play_order_expired():
	sfx_order_expired_player.stream = order_expired_sound
	sfx_order_expired_player.play()

func play_order_received():
	sfx_order_received_player.stream = order_received_sound
	sfx_order_received_player.play()

func play_snort():
	sfx_snort_player.stream = snort_sound
	sfx_snort_player.play()

func play_victory():
	sfx_victory_player.stream = victory_sound
	sfx_victory_player.play()

func play_wrong_order():
	sfx_wrong_order_player.stream = wrong_order_sound
	sfx_wrong_order_player.play()

