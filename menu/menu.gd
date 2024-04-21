extends Control

@onready var play_btn : Button = $MarginContainer/VBox_Botoes/Play

func _ready():
	play_btn.grab_focus()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://complete_game.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://menu/options_menu.tscn")
	
func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://tutorial.tscn")

func _on_quit_pressed():
	get_tree().quit()
