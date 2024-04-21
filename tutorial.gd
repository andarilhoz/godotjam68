extends Control

@onready var first_panel : TextureRect = $Control/Panel/TextureRect
@onready var second_panel : TextureRect = $Control/Panel/TextureRect2
@onready var third_panel : TextureRect = $Control/Panel/TextureRect3
@onready var fourth_panel : TextureRect = $Control/Panel/TextureRect4
@onready var fifth_panel : TextureRect = $Control/Panel/TextureRect5
@onready var sixth_panel : TextureRect = $Control/Panel/TextureRect6
@onready var seventh_panel : TextureRect = $Control/Panel/TextureRect7
@onready var eighth_panel : TextureRect = $Control/Panel/TextureRect8
@onready var ninth_panel : TextureRect = $Control/Panel/TextureRect9

@onready var previous_btn: Button = $Control/Panel/Previous
@onready var next_btn: Button = $Control/Panel/Next  # Supondo que há um botão chamado Next
@onready var back_btn: Button = $Control/VBox_Botoes/Back

# Lista para armazenar os painéis e facilitar a navegação entre eles
var panels = []
# Variável para controlar o índice do painel atual
var current_panel_index = 0

func _ready():
	# Adiciona todos os painéis à lista
	panels.append(first_panel)
	panels.append(second_panel)
	panels.append(third_panel)
	panels.append(fourth_panel)
	panels.append(fifth_panel)
	panels.append(sixth_panel)
	panels.append(seventh_panel)
	panels.append(eighth_panel)
	panels.append(ninth_panel)
	
	# Oculta todos os painéis, exceto o primeiro
	for i in range(1, panels.size()):
		panels[i].visible = false

	# Atualiza o estado dos botões
	update_button_state()
	
func _on_previous_pressed():
	if current_panel_index > 0:
		panels[current_panel_index].visible = false
		current_panel_index -= 1
		panels[current_panel_index].visible = true
	update_button_state()

func _on_next_pressed():
	if current_panel_index < panels.size() - 1:
		panels[current_panel_index].visible = false
		current_panel_index += 1
		panels[current_panel_index].visible = true
	update_button_state()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu/menu.tscn")

func update_button_state():
	if current_panel_index == 0:
		previous_btn.hide()
		next_btn.grab_focus()
	else:
		previous_btn.show()
	
	if (current_panel_index == panels.size() - 1):
		next_btn.hide()
		previous_btn.grab_focus()
	else:
		next_btn.show() 
	
