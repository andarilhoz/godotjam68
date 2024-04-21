extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://scripts/forge_enum.gd")

@export var storage_material : Item

func _ready():
	super._ready()
	sprite.texture = storage_material.deposit_sprite

func do_action(player_body: Node2D):
	super.do_action(player_body)
	player_body.reveice_material(storage_material)
	if storage_material.item_type == ForgeEnum.ForgeItem.IRON:
		SoundControl.play_take_iron()
		return
	SoundControl.play_take_wood()
		

func on_player_close(player: Player):
	if not _should_interact(player):
		return
	super.on_player_close(player)

func _should_interact(player: Player):
	return player.holding_material == null
