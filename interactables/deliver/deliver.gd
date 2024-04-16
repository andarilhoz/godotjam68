extends "res://interactables/interactable.gd"

@export var take_out_timer_in_seconds : float = 1
@onready var holding_item: TextureRect = $ItemSprite/ItemImage

func do_action(player_body: Player):
	if player_body.holding_material == null:
		print("No item in hand")
		return
	
	print("Delivering order: ", player_body.holding_material.get_item_name() )
	SignalManager.on_order_deliver.emit(player_body.holding_material)
	player_body.delete_material()

func item_take_out():
	pass

func on_player_close(player: Player):
	if player.holding_material == null:
		return
	super.on_player_close(player)
