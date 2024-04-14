extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://forge_enum.gd")

var holding_material : ForgeEnum.ForgeItem = ForgeEnum.ForgeItem.NONE

func do_action(player_body):
	if player_body.holding_material == ForgeEnum.ForgeItem.NONE:
		send_item(player_body)
		return
	
	reveice_material(player_body)
	
func send_item(player_body: Node2D):
	if holding_material == ForgeEnum.ForgeItem.NONE:
		print("No material to give")
		return
	player_body.reveice_material(holding_material)


func reveice_material(player_body: Node2D):
	if holding_material != ForgeEnum.ForgeItem.NONE:
		print("ERROR, already has material in table")
		return
	print("Received material: ", ForgeEnum.ForgeItem.keys()[player_body.holding_material])
	holding_material = player_body.holding_material
	player_body.delete_material()
