extends Control

@onready var text_label : RichTextLabel = $Panel/RichTextLabel
@export var points_per_order = 25

var points : int = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_order_successful.connect(increase_points)
	text_label.text = "[center]" + str(points) + "[/center]"

func increase_points():
	points += points_per_order
	text_label.text = "[center]" + str(points) + "[/center]"
