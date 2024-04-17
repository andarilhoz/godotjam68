class_name Interactable
extends Node2D

@onready var sprite : Sprite2D = $ItemSprite

var actionBtn : AnimatedSprite2D
var active: bool = false

var close_player: Player

func _should_interact(player: Player):
	return false

func _ready():
	actionBtn = $ActionBtn
	actionBtn.hide()

func _process(delta):
	if not active:
		return
	if Input.is_action_just_pressed("ui_action"):
		do_action(close_player)

func do_action(player_body: Player):
	print("Action called")

func on_player_leave():
	if not active:
		return
	print("disable: ", self.name)
	actionBtn.hide()
	close_player = null
	sprite.modulate = Color(1,1,1,1)
	active = false

func on_player_close(player: Player):
	if active:
		return
	print("enable: ", self.name)
	actionBtn.show()
	sprite.modulate = Color(1,1,1,0.5)
	close_player = player
	active = true
	
