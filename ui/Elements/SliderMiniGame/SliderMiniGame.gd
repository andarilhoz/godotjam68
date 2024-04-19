class_name SliderMinigame
extends Control


@onready var retrieve_slider: HSlider = $Panel/HSlider
@onready var slider_speed: float = 1.0

@onready var bg_animation: AnimatedTextureRect = $Panel/TextureRect
@onready var actionBtn_animation : AnimatedTextureRect = $Panel/ActionBtn
@onready var press_cd_timer : Timer = $Panel/PressCD
@onready var panel : Panel = $Panel

@export var right_zone_length = 0.3
@export var min_distance = 0.2 

signal on_minigame_end

var last_start_range = -1.0  # Inicializando com um valor fora do alcance possível

var current_slider_percent : float = 50.0
var slider_left : bool = true
var elapsed_time = 0.0 
var period = 2.0 

var can_press = true
var custom_style_box_texture :  StyleBoxTexture = StyleBoxTexture.new()
var texture : GradientTexture1D = GradientTexture1D.new()
var gradient : Gradient = Gradient.new()
var is_hidden: bool = true

var slider_min_value: float
var slider_max_value: float

var correct_hits : int = 0

var is_masterpiece : bool = false
var enabled: bool = false

var current_forge

func _ready():
	configure_style_texture()
	change_slider_pos()
	

func show_minigame(forge_id):
	change_slider_pos()
	current_forge = forge_id
	is_hidden = false
	enabled = true
	can_press = true
	
	
	correct_hits = 0
	var minigame_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	minigame_tween.tween_property(panel, "position", Vector2.ZERO, .5)

func hide_minigame():
	is_hidden = true
	press_cd_timer.stop()
	
	bg_animation.set_next_frame()
	actionBtn_animation.set_next_frame()
	
	current_forge = null
	enabled = false
	var minigame_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	minigame_tween.tween_property(panel, "position", Vector2(800,0), .5)


func configure_style_texture():
	retrieve_slider["theme_override_styles/slider"] = custom_style_box_texture
	
	gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	
	for i in gradient.get_point_count():
		gradient.remove_point(i)

	custom_style_box_texture.content_margin_bottom = 10
	custom_style_box_texture.content_margin_right = -1
	custom_style_box_texture.content_margin_top = 25
	custom_style_box_texture.content_margin_left = -1
	gradient.set_color(0, Color.DARK_RED)
	gradient.add_point(1, Color.LIME_GREEN)
	gradient.add_point(2, Color.DARK_RED)
	gradient.set_offset(0, 0)
	texture.set_gradient(gradient)
	texture.width = 256;

	custom_style_box_texture.texture = texture

func _process(delta):
	if not enabled:
		return
	slide(delta)
	if Input.is_action_just_pressed("ui_action"):
		press()
	
func press():
	if can_press == false:
		return
	print("pressed")
	can_press = false
	bg_animation.set_next_frame()
	actionBtn_animation.set_next_frame()
	var precise = check_hit_precision()
	
	if precise:
		print("precise: ", retrieve_slider.value )
		correct_hits += 1 
	else:
		print("not precise: ",retrieve_slider.value )
		correct_hits = 0
		
	if correct_hits >= 3:
		on_minigame_end.emit(is_masterpiece, current_forge)
		hide_minigame()
		
	else:
		press_cd_timer.start()
		change_slider_pos()
	

func check_hit_precision() -> bool:
	return retrieve_slider.value /100 > slider_min_value and retrieve_slider.value/100 < slider_max_value

func slide(delta):
	# Define o alvo com base na direção do slider
	var target: float = 0 if slider_left else 100
	elapsed_time += delta
	var new_position = (sin(elapsed_time * slider_speed * 2.0 * PI / period) + 1.0) * 0.5 * 100.0
	# Atualiza o valor do slider na UI
	retrieve_slider.value = new_position

func change_slider_pos():
	var start_min_range = 0.0
	
	# Calculando o máximo alcance inicial
	var start_max_range = 1 - right_zone_length

	# Determinando a faixa válida para start_range baseada na última posição
	var new_start_min = start_min_range
	var new_start_max = start_max_range

	if last_start_range != -1.0:
		if last_start_range + min_distance + right_zone_length <= 1:
			# A nova posição inicial pode começar após a última posição mais a distância mínima
			new_start_min = last_start_range + min_distance
		else:
			# A nova posição inicial deve começar em algum lugar antes da última posição menos a distância mínima
			new_start_max = last_start_range - min_distance
			if new_start_max < new_start_min:
				new_start_min = start_min_range  # Reset para evitar intervalo negativo

	# Escolhendo um valor aleatório dentro dos novos limites
	slider_min_value = randf_range(new_start_min, new_start_max)
	slider_max_value = slider_min_value + right_zone_length
	
	print("Min range: ", slider_min_value)
	print("Max range: ", slider_max_value)

	var offsets : PackedFloat32Array = PackedFloat32Array([0, slider_min_value, slider_max_value])
	gradient.offsets = offsets

	# Atualizando a última posição usada
	last_start_range = slider_min_value
	
func _on_press_cd_timeout():
	if not enabled:
		return
	bg_animation.set_next_frame()
	actionBtn_animation.set_next_frame()
	can_press = true
