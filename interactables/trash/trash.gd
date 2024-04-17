extends "res://interactables/interactable.gd"


func do_action(player_body: Node2D):
	player_body.delete_material()

func on_player_close(player: Player):
	if not _should_interact(player):
		return
	super.on_player_close(player)

func _should_interact(player: Player):
	return player.holding_material != null
