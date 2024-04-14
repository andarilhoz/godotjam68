extends Node2D

var actionBtn : AnimatedSprite2D
var active: bool = false

func _ready():
	actionBtn = $ActionBtn
	actionBtn.hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_action"):
		do_action()

func do_action():
	if not active:
		return
	print("Action called")

func _on_area_2d_body_entered(body):
	print("Entered body: ", body.name)
	if body.name != "Player":
		return
	
	active = true
	actionBtn.show()
	actionBtn.play()
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	print("Exited body: ", body.name)
	actionBtn.hide()
	active = false
	pass # Replace with function body.
