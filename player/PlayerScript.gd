class_name Player

extends CharacterBody2D

const ForgeEnum = preload("res://scripts/forge_enum.gd")

@onready var holding_item: TextureRect = $Smoothing2D/AnimatedSprite2D/HoldingItem
@onready var area2d : Area2D = $Area2D
@onready var player_sprite: AnimatedSprite2D = $Smoothing2D/AnimatedSprite2D
@export var speed_reducer_carry = 0.12

const max_speed = 550
const acceleration = 3500
const friction = 1500

var input = Vector2.ZERO

var holding_material: Item

var closest_interactable : Interactable = null

func _physics_process(delta):
	player_movement(delta)


func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

func process_animation():
	if velocity == Vector2.ZERO:
		if holding_material:
			player_sprite.animation = "idle_box"
		else:
			player_sprite.animation = "idle"
		return
	
	if holding_material:
		player_sprite.animation = "walk_box"
	else:
		player_sprite.animation = "walk"
		
	

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
		
	if holding_material != null:
		velocity = velocity * ( 1 - speed_reducer_carry)
	
	move_and_slide()
	if velocity.x != 0:  # verifica se há movimento horizontal
		player_sprite.flip_h = velocity.x < 0  # flipa horizontalmente se movendo para a esquerda
		$LightOccluder2D.scale = Vector2(-1,1) if velocity.x < 0 else Vector2(1,1)
	process_animation()

func reveice_material(material: Item):
	if holding_material != null:
		print("ERROR, already has material in hands")
		return
	print("Received material: ", material.get_item_name())
	holding_material = material
	holding_item.texture = material.sprite
	holding_item.show()
	
func delete_material():
	if holding_material == null:
		print("ERROR, no material in hand")
		return
	print("Removing material: ",  holding_material.get_item_name())
	holding_material = null
	holding_item.hide()
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			manual_process()

func _process(delta):		
	if not area2d.has_overlapping_bodies():
		return
	
	var bodies = area2d.get_overlapping_bodies()
	
	var interactables : Array[Interactable] = []
	for body in bodies:
		if not is_instance_valid(body) and not body is StaticBody2D:
			continue
		var parent = body.get_parent()
		if not parent is Interactable:
			continue
			
		if (parent as Interactable)._should_interact(self):
			interactables.append(parent)
	
	if interactables.size() < 1:
		return
		
	var current_closest = get_closest_interactable(interactables)
	if closest_interactable == current_closest:
		return
	
	if closest_interactable != null :
		closest_interactable.on_player_leave()
		
	current_closest.on_player_close(self)
	closest_interactable = current_closest

func manual_process():
	print("manual process")
	if not area2d.has_overlapping_bodies():
		return
	
	var bodies = area2d.get_overlapping_bodies()
	
	var interactables : Array[Interactable] = []
	for body in bodies:
		if not is_instance_valid(body) and not body is StaticBody2D:
			continue
		var parent = body.get_parent()
		if not parent is Interactable:
			continue
			
		if (parent as Interactable)._should_interact(self):
			interactables.append(parent)
	
	if interactables.size() < 1:
		return
		
	var current_closest = get_closest_interactable(interactables)
	if closest_interactable == current_closest:
		return
	
	if closest_interactable != null :
		closest_interactable.on_player_leave()
		
	current_closest.on_player_close(self)
	closest_interactable = current_closest

func get_closest_interactable(interactables: Array[Interactable]):
	var closest_interactable : Interactable = null
	var min_distance = INF
	
	for interactable in interactables:
		var distance = position.distance_squared_to(interactable.position)
		if distance < min_distance:
			min_distance = distance
			closest_interactable = interactable
	
	return closest_interactable

func _on_area_2d_body_exited(body):	
	if not is_instance_valid(body) and not body is StaticBody2D:
		return
		
	var parent = body.get_parent()
	if not parent is Interactable:
		return
		
	parent.on_player_leave()
	closest_interactable = null
