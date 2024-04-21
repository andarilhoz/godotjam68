extends Control

@onready var text_label : RichTextLabel = $CoinIcon/Contador_Estrelas
@onready var coin_icon : TextureRect = $CoinIcon
@onready var hourglass_icon : TextureRect = $TimerIcon
@export var points_loose_expire = 2
@export var points_loose_wrong = 1

@onready var endgame_panel = $"../EndgamePanel"

@export var level_timer_in_seconds: float = 180
@onready var timer : Timer = $LevelTimer
@onready var timer_label : RichTextLabel = $TimerIcon/Contador_Timer
	
@export var points_dict_percentage_over = {
	50 : "Good",
	20 : "Ok",
	 0 : "Meh"
}

@export var phase_target_points : int = 25
var points : int = 0;
var hourglass_wobbling : bool = false
var hourglass_critical_time: float = 10.0
var hourglass_color_tween : Tween
var critical_mode : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_order_successful.connect(increase_points)
	SignalManager.on_order_expired.connect(expired_order)
	SignalManager.on_order_misplaced.connect(wrong_order)
	text_label.text = "[center]" + str(points) + "[/center]"
	timer.start(level_timer_in_seconds)
	
func coin_wobble():
	var coin_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	coin_tween.tween_property(coin_icon, "scale", Vector2(1.25, 1.25), .25)
	coin_tween.tween_property(coin_icon, "scale", Vector2(1,1), .25)
	
func hourglass_wobble(percentage_time_left):
	if hourglass_wobbling:
		return
	hourglass_wobbling = true
	var hourglass_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).set_loops()
	hourglass_color_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).set_loops()
	hourglass_tween.tween_property(hourglass_icon, "rotation_degrees", 5.0, .5)
	hourglass_tween.tween_property(hourglass_icon, "rotation_degrees", -5.0, .5)
	hourglass_color_tween.tween_property(timer_label, "theme_override_colors/default_color", Color.RED, .5)
	hourglass_color_tween.tween_property(timer_label, "theme_override_colors/default_color", Color.WHITE, .5)

func critical_timing():
	if critical_mode:
		return
	critical_mode = true
	SoundControl.play_hurry_loop()
	hourglass_color_tween.kill()
	var critical_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).set_loops()
	critical_tween.tween_property(timer_label, "theme_override_colors/default_color", Color.RED, .1)
	critical_tween.tween_property(timer_label, "theme_override_colors/default_color", Color.WHITE, .1)
	
func _process(delta):
	if timer.time_left < 20:
		hourglass_wobble(timer.time_left/level_timer_in_seconds)
	if timer.time_left < hourglass_critical_time:
		critical_timing()
		
	timer_label.text = "[center]" + str(roundf(timer.time_left)) + "[/center]"

func _on_level_timer_timeout():
	get_tree().set_deferred("paused", true)
	endgame_panel.show_end_game(points, phase_target_points)
	print("End game...")

func increase_points(order):
	var percentage = order["percent"]
	var deliver_match = "Meh"
	for item in points_dict_percentage_over :
		if percentage >= item:
			deliver_match = points_dict_percentage_over[item]
			break
	var receive_points : int = (order["order"] as Order).deliver_values[deliver_match]
	print("points for: ", (order["order"] as Order).item.get_item_name())
	print("deliver match: ", deliver_match)
	print("is masterpiece: ", (order["item"] as Item).is_masterpiece)
	print("raw_points: ",receive_points )
	if (order["item"] as Item).is_masterpiece:
		receive_points += 1
	print("receive points: ", receive_points)
	points += receive_points
	coin_wobble()
	update_label()

func update_label():
	text_label.text = "[center]" + str(points) + "[/center]"

func wrong_order():
	points -= points_loose_wrong
	if points < 0:
		points = 0
	update_label()

func expired_order():
	points -= points_loose_expire
	if points < 0:
		points = 0
	update_label()
