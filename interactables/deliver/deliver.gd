extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://scripts/forge_enum.gd")
@export var take_out_timer_in_seconds : float = 2


@onready var holding_item: TextureRect = $ItemSprite/ItemImage
@onready var timer: Timer = $FadeTimer


func do_action(player_body: Player):
	if player_body.holding_material == null:
		print("No item in hand")
		return
	
	print("Delivering order: ", player_body.holding_material.get_item_name() )
	reveice_material(player_body.holding_material)
	SignalManager.on_order_deliver.emit(player_body.holding_material)
	player_body.delete_material()

func reveice_material(holding_material: Item):
	holding_item.show()
	holding_item.texture = holding_material.sprite
	timer.one_shot = true
	timer.start(take_out_timer_in_seconds)
	

func item_take_out():
	holding_item.hide()

func on_player_close(player: Player):
	if not _should_interact(player):
		return
	super.on_player_close(player)

func _should_interact(player: Player):
	return player.holding_material != null and (player.holding_material.item_type != ForgeEnum.ForgeItem.WOOD and player.holding_material.item_type != ForgeEnum.ForgeItem.IRON) 
		

func _on_fade_timer_timeout():
	item_take_out()
