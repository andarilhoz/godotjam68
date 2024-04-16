extends "res://interactables/interactable.gd"


func do_action(player_body: Node2D):
	player_body.delete_material()

func on_player_close(player: Player):
	if player.holding_material == null:
		return
	super.on_player_close(player)
