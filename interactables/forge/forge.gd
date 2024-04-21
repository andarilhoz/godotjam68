extends "res://interactables/interactable.gd"
const ForgeEnum = preload("res://scripts/forge_enum.gd")

@export var processing_time: float = 4
@export var recipes: Array[Order]
@onready var timer: Timer = $ProcessTimer

@onready var item_1: TextureRect = $Items/Item1
@onready var item_2: TextureRect = $Items/Item2
@onready var item_3: TextureRect = $Items/Item3

@onready var forged_item: TextureRect = $ForgedItem
@onready var slider_minigame : SliderMinigame = $"../InGame_CanvasLayer/SliderMiniGame"

@onready var player: Player = $"../Player"

const raw_materials = [ForgeEnum.ForgeItem.IRON, ForgeEnum.ForgeItem.WOOD]

var holding_itens : Array[Item]
var processing : bool = false
var processed_item: Item
var minigame_enabled: bool = false;

func _ready():
	super._ready()
	slider_minigame.on_minigame_end.connect(give_item)


func on_player_leave():
	super.on_player_leave()
	if processed_item:
		actionBtn.show()
		

func give_item(perfect, forge_id):
	print("received id", forge_id)
	print("myid", self.get_instance_id())
	if forge_id != self.get_instance_id():
		return
		
	var final_item = processed_item.masterpiece_version if perfect else processed_item
	SoundControl.play_take_weapon()
	player.reveice_material(final_item)
	processed_item = null
	minigame_enabled = false
	forged_item.hide()

func do_action(player_body):
	print("try action")
	if minigame_enabled:
		print("on minigame")
		return
	if processing :
		print("Forge busy")
		return
	if holding_itens.size() > 2:
		print("Forge is full")
		return
	if player_body.holding_material == null and processed_item == null:
		print("ERROR, no material in hands")
		return
	if player_body.holding_material != null and processed_item != null:
		print("busy forge")
		return
	
	if player_body.holding_material != null and raw_materials.has(player_body.holding_material.item_type) == false:
		print("Not raw material")
		return
	
	if processed_item != null and player_body.holding_material == null:
		print("Start minigame")
		minigame_enabled = true;
		slider_minigame.show_minigame(self.get_instance_id())
		return
	
	reveice_material(player_body)

func on_player_close(player: Player):
	if not _should_interact(player):
		return
	super.on_player_close(player)

func _should_interact(player: Player):
	return ((player.holding_material != null and processed_item == null) or (player.holding_material == null and processed_item != null) )and not processing

func reveice_material(player_body: Node2D):
	print("Received material: ", player_body.holding_material.get_item_name())
	holding_itens.append(player_body.holding_material)
	if player_body.holding_material.item_type == ForgeEnum.ForgeItem.WOOD:
		SoundControl.play_take_wood()
	else:
		SoundControl.play_take_iron()
	if holding_itens.size() > 2:
		start_processing()
	set_content_sprite()
	player_body.delete_material()

func set_content_sprite():
	if  holding_itens.size() > 0:
		item_1.show()
		item_1.texture = holding_itens[0].sprite
	else:
		item_1.hide()
		
	if holding_itens.size() > 1:
		item_2.show()
		item_2.texture = holding_itens[1].sprite
	else:
		item_2.hide()
		
	if  holding_itens.size() > 2:
		item_3.show()
		item_3.texture = holding_itens[2].sprite
	else:
		item_3.hide()

func start_processing():
	processing = true
	actionBtn.hide()
	timer.one_shot = true
	SoundControl.play_forge_machine()
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
		

func get_array_string_item_name(array_item: Array[Item]):
	var array_string: Array[String]
	for item in array_item:
		array_string.append(item.get_item_name())
	array_string.sort()
	return array_string
	

func get_right_recipe():
	var found_recipe : Order = null
	var holding_sorted = get_array_string_item_name(holding_itens)
	for recipe in recipes:
		var recipe_items = get_array_string_item_name(recipe.recipe_sprites)
		if recipe_items == holding_sorted:
			found_recipe = recipe
			break
	if found_recipe == null:
		print("Erro, isso não deveria acontecer: ", ",".join(holding_sorted))
		return
	processed_item = found_recipe.item
	forged_item.show()
	forged_item.texture = processed_item.sprite

func _on_process_timer_timeout():
	print("Timer end")
	get_right_recipe()
	actionBtn.show()
	$UI_ProgressBar.visible = false
	processing = false
	holding_itens.clear()
	set_content_sprite()
	
