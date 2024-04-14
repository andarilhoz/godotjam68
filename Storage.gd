extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://forge_enum.gd")

@export var storage_material = ForgeEnum.ForgeMaterial.WOOD

func do_action(player_body: Node2D):
	player_body.reveice_material(storage_material)
	print("Child call")