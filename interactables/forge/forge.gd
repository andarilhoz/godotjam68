extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://forge_enum.gd")

@export var processing_time: float = 2;
@onready var timer: Timer = $ProcessTimer

var holding_itens : Array[ForgeEnum.ForgeItem]
var processing : bool = false
var processed_item: ForgeEnum.ForgeItem = ForgeEnum.ForgeItem.NONE

func do_action(player_body):
	if processing :
		print("Forge busy")
		return
	if holding_itens.size() > 2:
		print("Forge is full")
		return
	if player_body.holding_material == ForgeEnum.ForgeItem.NONE and processed_item == ForgeEnum.ForgeItem.NONE:
		print("ERROR, no material in hands")
		return
	
	if processed_item != ForgeEnum.ForgeItem.NONE and player_body.holding_material == ForgeEnum.ForgeItem.NONE:
		print("Giving player material")
		player_body.reveice_material(processed_item)
		processed_item = ForgeEnum.ForgeItem.NONE
		return
	
	reveice_material(player_body)

func reveice_material(player_body: Node2D):
	print("Received material: ", ForgeEnum.ForgeItem.keys()[player_body.holding_material])
	holding_itens.append(player_body.holding_material)
	if holding_itens.size() > 2:
		start_processing()
	player_body.delete_material()

func start_processing():
	processing = true
	timer.one_shot = true
	timer.start(processing_time)
	print("start forge")
	

func _process(delta):
	super._process(delta)
	if processing != true:
		return
	if timer.time_left > 0:
		$UI_ProgressBar.visible = true
		var percent_of_time = ( (1 - timer.time_left / timer.wait_time) * 100)
		var use_int = int(percent_of_time)
		$UI_ProgressBar.get_node("Panel").material.set_shader_parameter("Percent", use_int)
		print("Timer time: ", use_int)
	

func _on_process_timer_timeout():
	print("Timer end")
	$UI_ProgressBar.visible = false
	processing = false
	holding_itens.clear()
	processed_item = ForgeEnum.ForgeItem.SWORD
	pass # Replace with function body.
