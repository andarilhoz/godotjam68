class_name SliderMinigame
extends Control

@onready var retrieve_slider: HSlider = $Panel/HSlider
@onready var slider_speed: float = 1.8
@onready var slider_speed_masterpiece: float = 2.2

@onready var bg_animation: AnimatedTextureRect = $Panel/TextureRect
@onready var actionBtn_animation : AnimatedTextureRect = $Panel/ActionBtn
@onready var press_cd_timer : Timer = $Panel/PressCD
@onready var panel : Panel = $Panel
@onready var player: Player = $"../../Player"
@onready var explosion_particle : GPUParticles2D = $Panel/Explosion

@export var right_zone_length = 0.3
@export var right_zone_length_masterpiece = 0.1
@export var min_distance = 0.2 

@export var safe_threshold = 0.025

@export var empty_marker : Texture
@export var filled_marker : Texture
@export var masterpiece_chance: float = 17.0
@export var markers : Array[TextureRect]

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
var last_input_device: String

func _ready():
	configure_style_texture()
	change_slider_pos()
	

func show_minigame(forge_id):
	actionBtn_animation.current_animation = last_input_device
	actionBtn_animation.set_next_frame()
	actionBtn_animation.set_next_frame()
	current_forge = forge_id
	is_hidden = false
	player.is_forging = true
	enabled = true
	is_masterpiece = chance_true(masterpiece_chance)
	change_slider_pos()
	update_slider_colors()
	can_press = true
	correct_hits = 0
	update_markers()
	var minigame_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	minigame_tween.tween_property(panel, "position", Vector2.ZERO, .5)
	
func shake_panel(x_intensity: float, y_intensity: float, duration: float):
	var minigame_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	var original_position = panel.position  # Armazena a posição original do painel.
	
	# Define os parâmetros do tremor.
	var shake_steps = 10  # Quantidade de tremidas.
	var shake_duration = duration / shake_steps  # Duração de cada tremida.
	
	for i in range(shake_steps):
		# Cada tremida é uma interpolação para uma nova posição aleatória baseada na intensidade.
		var random_x = original_position.x + randf_range(-x_intensity, x_intensity)
		var random_y = original_position.y + randf_range(-y_intensity, y_intensity)
		minigame_tween.tween_property(panel, "position", Vector2(random_x, random_y), shake_duration)
	
	# No final, adiciona uma interpolação para retornar à posição original.
	minigame_tween.tween_property( panel, "rect_position", original_position, shake_duration)

	



func hide_minigame():
	is_hidden = true
	press_cd_timer.stop()
	player.is_forging = false
	bg_animation.set_next_frame()
	actionBtn_animation.set_next_frame()
	
	current_forge = null
	enabled = false
	var minigame_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
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
		
		
func _input(event):
	if event is InputEventKey or event is InputEventMouse:
		last_input_device = "keyboard"
		return
	last_input_device = "controller"
	actionBtn_animation.current_animation = last_input_device


func update_slider_colors():
	if is_masterpiece :
		gradient.set_color(0, Color.WEB_PURPLE)
		gradient.set_color(1, Color.GOLD)
		gradient.set_color(2, Color.WEB_PURPLE)
		return
	gradient.set_color(0, Color.DARK_RED)
	gradient.set_color(1, Color.LIME_GREEN)
	gradient.set_color(2, Color.DARK_RED)
	
func press():
	if can_press == false:
		return
	print("pressed")
	can_press = false
	Input.start_joy_vibration(0,1,1,.15)
	bg_animation.set_next_frame()
	actionBtn_animation.set_next_frame()
	var precise = check_hit_precision()
	
	if precise:
		print("precise: ", retrieve_slider.value )
		SoundControl.play_forge_hit()
		if is_masterpiece:
			SoundControl.play_masterpiece()
		correct_hits += 3 if is_masterpiece else 1
	else:
		SoundControl.play_forge_miss()
		print("not precise: ",retrieve_slider.value )
		correct_hits = 0
	var video_settings = ConfigFileHandler.load_video_settings()
	
	if video_settings["screen_shake"]:
		shake_panel(10, 10, 0.5)
		
	explosion_particle.restart() 
	press_cd_timer.start()
	update_markers()

func update_markers():
	for i in range(3):
		if correct_hits >= i + 1 :
			markers[i].texture = filled_marker
			continue
		markers[i].texture = empty_marker
	
func chance_true(percentage):
	percentage = clamp(percentage, 0.0, 100.0)
	var rand_num = randf_range(0.0, 100.0)
	return rand_num < percentage

func check_hit_precision() -> bool:
	return retrieve_slider.value /100 > slider_min_value - safe_threshold and retrieve_slider.value/100 < slider_max_value + safe_threshold

func slide(delta):
	if not can_press:
		return
	var target_speed = slider_speed_masterpiece if is_masterpiece else slider_speed
	# Define o alvo com base na direção do slider
	var target: float = 0 if slider_left else 100
	elapsed_time += delta
	var new_position = (sin(elapsed_time * target_speed * 2.0 * PI / period) + 1.0) * 0.5 * 100.0
	# Atualiza o valor do slider na UI
	retrieve_slider.value = new_position
	

func change_slider_pos():	
	var start_min_range = 0.0
	var right_zone_target = right_zone_length_masterpiece if is_masterpiece else right_zone_length
	# Calculando o máximo alcance inicial
	var start_max_range = 1 - right_zone_target

	# Determinando a faixa válida para start_range baseada na última posição
	var new_start_min = start_min_range
	var new_start_max = start_max_range

	if last_start_range != -1.0:
		if last_start_range + min_distance + right_zone_target <= 1:
			# A nova posição inicial pode começar após a última posição mais a distância mínima
			new_start_min = last_start_range + min_distance
		else:
			# A nova posição inicial deve começar em algum lugar antes da última posição menos a distância mínima
			new_start_max = last_start_range - min_distance
			if new_start_max < new_start_min:
				new_start_min = start_min_range  # Reset para evitar intervalo negativo

	# Escolhendo um valor aleatório dentro dos novos limites
	slider_min_value = randf_range(new_start_min, new_start_max)
	slider_max_value = slider_min_value + right_zone_target
	
	print("Min range: ", slider_min_value)
	print("Max range: ", slider_max_value)

	var offsets : PackedFloat32Array = PackedFloat32Array([0, slider_min_value, slider_max_value])
	gradient.offsets = offsets

	# Atualizando a última posição usada
	last_start_range = slider_min_value
	
func _on_press_cd_timeout():
	if not enabled:
		return
		
	if correct_hits >= 3:
		on_minigame_end.emit(is_masterpiece, current_forge)
		hide_minigame()
		return
		
	is_masterpiece = chance_true(masterpiece_chance)
	change_slider_pos()
	update_slider_colors()
	bg_animation.set_next_frame()
	actionBtn_animation.set_next_frame()
	can_press = true
