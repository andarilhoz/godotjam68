extends Panel

@onready var text_edit = $Paper/TextureRect/TextEdit
@onready var label_video = $"Paper/TextureRect/TextureRect/Label - Video"
@onready var panel = $Paper

var points: int = 0

func _ready():
	panel.scale = Vector2.ZERO

func open_panel(received_points: int):
	label_video.text = str(received_points)
	points = received_points
	show()
	var highscore_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	highscore_tween.tween_property(panel, "scale", Vector2.ONE, .5)
	
func _on_send_pressed():
	SilentWolf.Scores.save_score(text_edit.text, points)
	ConfigFileHandler.save_highscore(points)

func _on_next_pressed():
	var highscore_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	highscore_tween.tween_property(panel, "scale", Vector2.ZERO, .5)
	highscore_tween.finished.connect(hide)
