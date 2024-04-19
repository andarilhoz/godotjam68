extends Control

@onready var text_label : RichTextLabel = $CoinIcon/Contador_Estrelas
@export var points_per_order = 25
@export var points_loose_expire = 5
@export var points_loose_wrong = 10

@export var points_dict_percentage_over = {
	50 : "Good",
	20 : "Ok",
	 0 : "Meh"
}

var points : int = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_order_successful.connect(increase_points)
	SignalManager.on_order_expired.connect(expired_order)
	SignalManager.on_order_misplaced.connect(wrong_order)
	text_label.text = "[center]" + str(points) + "[/center]"

func increase_points(order):
	var percentage = order["percent"]
	var deliver_match = "Meh"
	for item in points_dict_percentage_over :
		if percentage >= item:
			deliver_match = points_dict_percentage_over[item]
			break
	var receive_points : int = (order["order"] as Order).deliver_values[deliver_match]
	print("points for: ", (order["order"] as Order).item.get_item_name())
	print("deliver match: ", deliver_match)
	print("is masterpiece: ", (order["item"] as Item).is_masterpiece)
	print("raw_points: ",receive_points )
	if (order["item"] as Item).is_masterpiece:
		receive_points += 1
	print("receive points: ", receive_points)
	points += receive_points
	update_label()

func update_label():
	text_label.text = "[center]" + str(points) + "[/center]"

func wrong_order():
	points -= points_loose_wrong
	if points < 0:
		points = 0
	update_label()

func expired_order():
	points -= points_loose_expire
	if points < 0:
		points = 0
	update_label()
