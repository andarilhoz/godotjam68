extends Control

@onready var recipe_icon: TextureRect = $Panel/RecipeIcon

@onready var item_1: TextureRect = $Panel/HBoxContainer/Item1
@onready var item_2: TextureRect = $Panel/HBoxContainer/Item2
@onready var item_3: TextureRect = $Panel/HBoxContainer/Item3

@onready var timer: Timer = $Panel/OrderTimeout

@onready var panel: Panel = $Panel


signal on_card_expire
signal on_card_disapear

func tween_card():
	var card_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	card_tween.tween_property(panel, "scale", Vector2(1,1), .5)

func card_disapear():
	print("Disapear")
	on_card_disapear.emit()
	queue_free()

func expire():
	var card_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	card_tween.tween_property(panel, "scale", Vector2.ZERO, .5)
	card_tween.finished.connect(queue_free)
	on_card_disapear.emit()

func initialize_card(order: Order):
	tween_card()
	recipe_icon.texture = order.item.sketch_sprite
	
	item_1.texture = order.recipe_sprites[0].sprite
	item_2.texture = order.recipe_sprites[1].sprite
	item_3.texture = order.recipe_sprites[2].sprite
	
	timer.one_shot = true
	timer.start(order.expire_time_in_seconds)
	SoundControl.play_order_received()

func _process(delta):
	var percent_of_time: float = get_percentage_time()
	$Panel/TextureRect.material.set_shader_parameter("Percent", percent_of_time)

func get_percentage_time():
	return 100 - ( (1 - timer.time_left / timer.wait_time) * 100)

func _on_order_timeout_timeout():
	on_card_expire.emit(self)
