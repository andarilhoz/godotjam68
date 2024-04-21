extends Control

@onready var rich_text_labels = [
	$"Control/VBoxContainer/Panel - Scores/VBoxContainer/RichTextLabel1",
	$"Control/VBoxContainer/Panel - Scores/VBoxContainer/RichTextLabel2",
	$"Control/VBoxContainer/Panel - Scores/VBoxContainer/RichTextLabel3",
	$"Control/VBoxContainer/Panel - Scores/VBoxContainer/RichTextLabel4",
	$"Control/VBoxContainer/Panel - Scores/VBoxContainer/RichTextLabel5"
]

@onready var back = $Control/VBox_Botoes/Back

# Called when the node enters the scene tree for the first time.
func _ready():
	for label in rich_text_labels:
		label.hide()
	
	back.grab_focus()
	# Aqui assumimos que você obtém os resultados dos scores de forma assíncrona
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	update_scores(sw_result)

func update_scores(sw_result: Dictionary):
	# Verifica se há uma chave 'scores' no dicionário resultante e se ela contém uma lista
	if "scores" in sw_result and typeof(sw_result["scores"]) == TYPE_ARRAY:
		# Itera sobre os resultados dos scores e atualiza os RichTextLabel correspondentes
		for i in range(min(sw_result["scores"].size(), rich_text_labels.size())):
			var score = sw_result["scores"][i]
			rich_text_labels[i].show()
			rich_text_labels[i].bbcode_text = "[center]" + str(score.score) + " - " + str(score.player_name) + "[/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_pressed():
	SceneTransition.change_scene_to_file("res://menu/menu.tscn")
