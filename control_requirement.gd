extends Control

@onready var timer : Timer = $Timer

func _ready():
	timer.start()

func _on_timer_timeout():
	SceneTransition.change_scene_to_file("res://menu/menu.tscn")
