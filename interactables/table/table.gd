extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://scripts/forge_enum.gd")

var holding_material : Item = null
@onready var holding_item: TextureRect = $ItemSprite/Control/ItemImage

func do_action(player_body):
	super.do_action(player_body)
	if player_body.holding_material == null:
		send_item(player_body)
		return
	
	reveice_material(player_body)
	
func send_item(player_body: Node2D):
	if holding_material == null:
		print("No material to give")
		return
	player_body.reveice_material(holding_material)
	if holding_material.item_type == ForgeEnum.ForgeItem.WOOD:
		SoundControl.play_take_wood()
	else :
		SoundControl.play_take_iron()
	holding_material = null
	holding_item.hide()

func on_player_close(player: Player):
	if not _should_interact(player):
		return
	super.on_player_close(player)
	
func _should_interact(player: Player):
	return player.holding_material != null or holding_material != null

func reveice_material(player_body: Node2D):
	if holding_material != null:
		print("ERROR, already has material in table")
		return
	print("Received material: ", player_body.holding_material.get_item_name())
	holding_material = player_body.holding_material
	if holding_material.item_type == ForgeEnum.ForgeItem.WOOD:
		SoundControl.play_take_wood()
	else :
		SoundControl.play_take_iron()
	holding_item.texture = holding_material.sprite
	holding_item.show()
	player_body.delete_material()
