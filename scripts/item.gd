extends Resource


class_name Item
const ForgeEnum = preload("res://scripts/forge_enum.gd")
@export var item_type : ForgeEnum.ForgeItem
@export var sprite : Texture
@export var deposit_sprite : Texture

func get_item_name():
	return ForgeEnum.ForgeItem.keys()[item_type]
