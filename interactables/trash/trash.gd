extends "res://interactables/interactable.gd"


func do_action(player_body: Node2D):
	player_body.delete_material()