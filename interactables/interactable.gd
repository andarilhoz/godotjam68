class_name Interactable
extends Node2D

@onready var sprite : Sprite2D = $ItemSprite

@onready var actionBtn : AnimatedSprite2D = $ActionBtn
var active: bool = false

var close_player: Player

var last_input_device: String

func _should_interact(player: Player):
	return false

func _ready():
	actionBtn.hide()

func _input(event):
	if event is InputEventKey or event is InputEventMouse:
		last_input_device = "keyboard"
		return
	last_input_device = "controller"

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
	actionBtn.hide()
	close_player = null
	sprite.material.set_shader_parameter("should_apply", false)
	active = false

func on_player_close(player: Player):
	if active:
		return
	
	actionBtn.animation = last_input_device
	actionBtn.show()
	
	sprite.material.set_shader_parameter("should_apply", true)
	close_player = player
	active = true
	
