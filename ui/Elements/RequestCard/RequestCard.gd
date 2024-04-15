extends Control

@onready var recipe_icon: TextureRect = $Panel/RecipeIcon

@onready var item_1: TextureRect = $Panel/HBoxContainer/Item1
@onready var item_2: TextureRect = $Panel/HBoxContainer/Item2
@onready var item_3: TextureRect = $Panel/HBoxContainer/Item3

@onready var timer: Timer = $OrderTimeout

signal on_card_expire

func initialize_card(order: Order):
	recipe_icon.texture = order.item.sprite
	
	item_1.texture = order.recipe_sprites[0].sprite
	item_2.texture = order.recipe_sprites[1].sprite
	item_3.texture = order.recipe_sprites[2].sprite
	
	timer.one_shot = true
	timer.start(order.expire_time_in_seconds)


func _on_order_timeout_timeout():
	on_card_expire.emit(self)
