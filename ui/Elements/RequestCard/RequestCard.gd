extends Control

@onready var recipe_icon: TextureRect = $Panel/RecipeIcon

@onready var item_1: TextureRect = $Panel/HBoxContainer/Item1
@onready var item_2: TextureRect = $Panel/HBoxContainer/Item2
@onready var item_3: TextureRect = $Panel/HBoxContainer/Item3

func set_sprites(order: Order):
	recipe_icon.texture = order.item.sprite
	
	item_1.texture = order.recipe_sprites[0].sprite
	item_2.texture = order.recipe_sprites[1].sprite
	item_3.texture = order.recipe_sprites[2].sprite
