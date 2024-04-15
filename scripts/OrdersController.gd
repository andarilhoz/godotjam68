extends GridContainer
const ForgeEnum = preload("res://scripts/forge_enum.gd")
const request_card = preload("res://ui/Elements/RequestCard/RequestCard.tscn")

@onready var timer: Timer = $OrderCountDown
@export var time_between_orders: float = 5
@export var min_time_between_orders: float = 1
@export var decrease_time_between_orders: float = 0.25
@export var max_orders = 5

@export var item_list: Array[Order]

@export var order_list: Array[Order]


func _ready():
	timer.one_shot = true
	generate_order()

func generate_order():
	if order_list.size() >= max_orders:
		print("Max array size, waiting")
		timer.start(time_between_orders)
		return

	var random_item = randi() % item_list.size()
	order_list.append(item_list[random_item])
	print("Added item to the list: ",  ForgeEnum.ForgeItem.keys()[item_list[random_item].item.item_type])
	instantiate_card(item_list[random_item])
	print("List size: ", order_list.size())
	timer.start(time_between_orders)
	time_between_orders = time_between_orders - decrease_time_between_orders
	if time_between_orders < min_time_between_orders:
		time_between_orders = min_time_between_orders

func instantiate_card(item: Order):
	var request_card_item = request_card.instantiate()	
	add_child(request_card_item)
	request_card_item.set_sprites(item)
	

func _on_order_count_down_timeout():
	generate_order()
