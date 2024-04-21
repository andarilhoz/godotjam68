extends Control

@onready var back = $Control/VBox_Botoes/Back

func _ready():
	back.grab_focus()



func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu/menu.tscn")
