extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://scripts/forge_enum.gd")

@export var storage_material : Item

func do_action(player_body: Node2D):
	player_body.reveice_material(storage_material)
