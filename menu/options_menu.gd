extends Control

@onready var volume_btn : Button = $MarginContainer/VBoxContainer/Volume

func _ready():
	volume_btn.grab_focus()

func _on_volume_pressed():
	pass # Replace with function body.

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu/menu.tscn")
