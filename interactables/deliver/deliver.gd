extends "res://interactables/interactable.gd"

func do_action(body: Node2D):
	if player_body.holding_material == null:
		print("No item in hand")
		return
	print("Delivering order: ", player_body.holding_material.get_item_name() )
	SignalManager.on_order_deliver.emit(player_body.holding_material)
	player_body.delete_material()
