extends Node2D

var actionBtn : AnimatedSprite2D
var active: bool = false

var player_body: Node2D

func _ready():
	actionBtn = $ActionBtn
	actionBtn.hide()

func _process(delta):
	if not active:
		return
	if Input.is_action_just_pressed("ui_action"):
		do_action(player_body)

func do_action(body: Node2D):
	print("Action called")

func _on_area_2d_body_entered(body):
	print("Entered body: ", body.name)
	if body.name != "Player":
		return
	
	player_body = body
	active = true
	actionBtn.show()
	actionBtn.play()
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	print("Exited body: ", body.name)
	actionBtn.hide()
	player_body = null
	active = false
	pass # Replace with function body.
