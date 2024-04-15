extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://forge_enum.gd")

var holding_material : Item = null
@onready var holding_item: TextureRect = $HoldingItem

func do_action(player_body):
	if player_body.holding_material == null:
		send_item(player_body)
		return
	
	reveice_material(player_body)
	
func send_item(player_body: Node2D):
	if holding_material == null:
		print("No material to give")
		return
	player_body.reveice_material(holding_material)
	holding_material = null
	holding_item.hide()


func reveice_material(player_body: Node2D):
	if holding_material != null:
		print("ERROR, already has material in table")
		return
	print("Received material: ", ForgeEnum.ForgeItem.keys()[player_body.holding_material.item_type])
	holding_material = player_body.holding_material
	holding_item.texture = holding_material.sprite
	holding_item.show()
	player_body.delete_material()
