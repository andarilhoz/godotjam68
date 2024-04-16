extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://scripts/forge_enum.gd")

@export var storage_material : Item

func _ready():
	super._ready()
	sprite.texture = storage_material.deposit_sprite

func do_action(player_body: Node2D):
	player_body.reveice_material(storage_material)

func on_player_close(player: Player):
	if player.holding_material != null:
		return
	super.on_player_close(player)
