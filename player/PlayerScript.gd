extends CharacterBody2D

const ForgeEnum = preload("res://forge_enum.gd")

const max_speed = 70
const acceleration = 800
const friction = 1000

var input = Vector2.ZERO

var holding_material: ForgeEnum.ForgeMaterial = ForgeEnum.ForgeMaterial.NONE

func _physics_process(delta):
	player_movement(delta)

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * acceleration * delta)
		velocity = velocity.limit_length(max_speed)
	
	move_and_slide()

func reveice_material(material: ForgeEnum.ForgeMaterial):
	if holding_material != ForgeEnum.ForgeMaterial.NONE:
		print("ERROR, already has material in hands")
		return
	print("Received material: ", ForgeEnum.ForgeMaterial.keys()[material])
	holding_material = material
		
