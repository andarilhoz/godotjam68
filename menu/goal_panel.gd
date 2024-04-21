extends Panel

@onready var panel : Panel = $Paper
@onready var points_label : RichTextLabel = $"Paper/TextureRect/TextureRect/Label - Video"
@onready var label_panel = $"Paper/TextureRect/Label - Video"
@onready var start = $Paper/TextureRect/Start

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_deferred("paused", true)
	points_label.text = "[center]" + str(UIContadores.phase_target_points) + "[/center]"
	show()
	start.grab_focus()


func _on_start_pressed():
	print("start")
	var goal_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	goal_tween.tween_property(panel, "scale", Vector2.ZERO, .5)
	goal_tween.tween_property(self, "modulate:a", 0, .5)
	goal_tween.finished.connect(_on_close)


func _on_close():
	hide()
	get_tree().set_deferred("paused", false)

func _on_menu_pressed():
	SoundControl.stop_all_sfx()
	get_tree().set_deferred("paused", false)
	get_tree().change_scene_to_file("res://menu/menu.tscn")
