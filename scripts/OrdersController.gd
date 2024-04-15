extends GridContainer
const ForgeEnum = preload("res://scripts/forge_enum.gd")
const request_card = preload("res://ui/Elements/RequestCard/RequestCard.tscn")

@onready var timer: Timer = $OrderCountDown
@export var time_between_orders: float = 5
@export var min_time_between_orders: float = 1
@export var decrease_time_between_orders: float = 0.25
@export var max_orders = 5

@export var item_list: Array[Order]

@export var order_list : Dictionary

func _ready():
	SignalManager.on_order_deliver.connect(_on_order_received)
	timer.one_shot = true
	generate_order()
	

func generate_order():
	if order_list.size() >= max_orders:
		print("Max array size, waiting")
		timer.start(time_between_orders)
		return

	var random_item = randi() % item_list.size()
	var request_card_item = instantiate_card(item_list[random_item])
	print("Added item to the list: ", item_list[random_item].item.get_item_name())
	order_list[request_card_item.get_instance_id()] = {"order": item_list[random_item], "card": request_card_item}
	timer.start(time_between_orders)
	time_between_orders = time_between_orders - decrease_time_between_orders
	if time_between_orders < min_time_between_orders:
		time_between_orders = min_time_between_orders

func instantiate_card(item: Order):
	var request_card_item = request_card.instantiate()	
	add_child(request_card_item)
	request_card_item.initialize_card(item)
	request_card_item.on_card_expire.connect(_on_card_expire)
	return request_card_item
	

func _on_order_count_down_timeout():
	generate_order()
	
func _on_order_received(item: Item):
	print("Deliver received item: ", item.get_item_name())
	var order = get_order_by_item(item)
	if order == null:
		SignalManager.on_order_misplaced.emit()
		return
	remove_order(order["index"])
	SignalManager.on_order_successful.emit()
	pass

func remove_order(index):
	order_list[index]["card"].queue_free()	
	order_list.erase(index)

func _on_card_expire(card: Node):
	print("Node expired: ", card.get_instance_id())
	remove_order(card.get_instance_id())
	pass

func get_order_by_item(item: Item):
	var order_match
	for key in order_list:
		if order_list[key]["order"].item.get_item_name() == item.get_item_name():
			order_match = {"index": key, "order":order_list[key]["order"]}
			break
	return order_match
			
