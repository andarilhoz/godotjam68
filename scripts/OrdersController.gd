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
var request_card_list: Array[Node]


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
	order_list.append(item_list[random_item])
	print("Added item to the list: ", item_list[random_item].item.get_item_name())
	instantiate_card(item_list[random_item])
	print("List size: ", order_list.size())
	timer.start(time_between_orders)
	time_between_orders = time_between_orders - decrease_time_between_orders
	if time_between_orders < min_time_between_orders:
		time_between_orders = min_time_between_orders

func instantiate_card(item: Order):
	var request_card_item = request_card.instantiate()	
	add_child(request_card_item)
	request_card_item.initialize_card(item)
	request_card_item.on_card_expire.connect(_on_card_expire)
	request_card_list.append(request_card_item)
	

func _on_order_count_down_timeout():
	generate_order()
	
func _on_order_received(item: Item):
	print("Deliver received item: ", item.get_item_name())
	var order = get_order_by_item(item)
	if order == null:
		SignalManager.on_order_misplaced.emit()
		return
	order_list.remove_at(order["index"])
	var request_card = request_card_list[order["index"]]
	request_card.queue_free()
	request_card_list.remove_at(order["index"])
	
	SignalManager.on_order_deliver.emit()
	pass

func _on_card_expire():
	pass

func get_order_by_item(item: Item):
	var order_match
	for index in range(order_list.size()):
		if order_list[index].item.get_item_name() == item.get_item_name():
			order_match = {"index": index, "order":order_list[index]}
			break
	return order_match
			
