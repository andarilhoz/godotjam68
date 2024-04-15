extends Node2D
const ForgeEnum = preload("res://forge_enum.gd")

@onready var timer: Timer = $OrderCountDown
@export var time_between_orders: float = 5
@export var min_time_between_orders: float = 1
@export var decrease_time_between_orders: float = 0.25
@export var max_orders = 5
@export var item_list: Array[ForgeEnum.ForgeItem]

@export var order_list: Array[ForgeEnum.ForgeItem]

signal on_generate_order

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
	print("Added item to the list: ",  ForgeEnum.ForgeItem.keys()[item_list[random_item]])
	on_generate_order.emit(item_list[random_item])
	print("List size: ", order_list.size())
	timer.start(time_between_orders)
	time_between_orders = time_between_orders - decrease_time_between_orders
	if time_between_orders < min_time_between_orders:
		time_between_orders = min_time_between_orders

func _on_order_count_down_timeout():
	generate_order()
