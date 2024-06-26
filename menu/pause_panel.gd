extends Panel

@onready var panel : Panel = $Paper
@onready var points_label : RichTextLabel = $"Paper/TextureRect/TextureRect/Label - Video"
@onready var label_panel = $"Paper/TextureRect/Label - Video"
@onready var resume = $Paper/TextureRect/Resume
@onready var esc_cd : Timer = $EscCD

var paused = true

var can_esc = false

# Called when the node enters the scene tree for the first time.
func _ready():
	panel.scale = Vector2.ZERO


func _on_resume_pressed():
	can_esc = false
	var endgame_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	endgame_tween.tween_property(panel, "scale", Vector2.ZERO, .5)
	endgame_tween.tween_property(self, "modulate:a", 0, .5)
	endgame_tween.finished.connect(_on_close)

func pause_game():
	show()
	can_esc = false
	esc_cd.start()
	get_tree().set_deferred("paused", true)
	var endgame_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	endgame_tween.tween_property(self, "modulate:a", 1, .5)
	endgame_tween.tween_property(panel, "scale", Vector2.ONE, .5)
	resume.grab_focus()
	paused = true

func _process(delta):
	if not can_esc: 
		return
	if Input.is_action_just_pressed("ui_select_pause"):
		_on_resume_pressed()

func _on_close():
	hide()
	get_tree().set_deferred("paused", false)
	paused = false
	
func _on_restart_pressed():
	print("restarting")
	SoundControl.stop_all_sfx()
	get_tree().set_deferred("paused", false)
	get_tree().reload_current_scene()

func _on_menu_pressed():
	SoundControl.stop_all_sfx()
	get_tree().set_deferred("paused", false)
	SceneTransition.change_scene_to_file("res://menu/menu.tscn")

func _on_esc_cd_timeout():
	print("now can esc")
	can_esc = true
