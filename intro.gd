extends Control

@onready var explosion :GPUParticles2D = $Explosion


func _ready():
	explosion.restart()
	SoundControl.play_forge_hit()
	SoundControl.play_menu_music()
	explosion.finished.connect(transition_menu)

func transition_menu():
	SceneTransition.change_scene_to_file("res://control_requirement.tscn")
