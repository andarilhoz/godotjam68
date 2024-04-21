extends Panel

@onready var panel : Panel = $Paper
@onready var points_label : RichTextLabel = $"Paper/TextureRect/TextureRect/Label - Video"
@onready var label_panel = $"Paper/TextureRect/Label - Video"
@onready var restart = $Paper/TextureRect/Restart

# Called when the node enters the scene tree for the first time.
func _ready():
	panel.scale = Vector2.ZERO


func show_end_game(points: int, target_points: int):
	show()
	$Paper/TextureRect/Restart.grab_focus()
	restart.grab_focus()
	print("Ending")
	var endgame_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	endgame_tween.tween_property(panel, "scale", Vector2.ONE, .5)
	points_label.text = "[center]" + str(points) + "/" + str(target_points) + "[/center]"
	label_panel.text = "[center]" + ("Success" if points >= target_points else "Game over") + "[/center]"
	
func _on_restart_pressed():
	print("restarting")
	SoundControl.stop_all_sfx()
	get_tree().set_deferred("paused", false)
	get_tree().reload_current_scene()
	

func _on_menu_pressed():
	SoundControl.stop_all_sfx()
	get_tree().set_deferred("paused", false)
	get_tree().change_scene_to_file("res://menu/menu.tscn")
