extends Node2D

@export var level_timer_in_seconds: float = 120
@onready var timer : Timer = $LevelTimer
@onready var timer_label : RichTextLabel = $InGame_CanvasLayer/Timer/UiTimer/Panel/RichTextLabel
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

func _ready():
	$InGame_CanvasLayer.visible = true
	timer.one_shot
	timer.start(level_timer_in_seconds)

func _process(delta):
	timer_label.text = "[center]" + str(roundf(timer.time_left)) + "[/center]"

func _on_level_timer_timeout():
	print("End game...")
