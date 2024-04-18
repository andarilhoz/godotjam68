extends PointLight2D

# Parâmetros ajustáveis para o flickering
@export var flicker_intensity_min = 0.5
@export var flicker_intensity_max = 1.2
@export var flicker_frequency = 0.1  # Tempo em segundos entre as mudanças de intensidade
@export var transition_speed = 10
@onready var timer: Timer = $FlickerForgeLightTimer

var target_energy = 1.0  # Alvo inicial para a energia da luz

func _ready():
	# Configura e inicia o timer
	timer.wait_time = flicker_frequency
	timer.autostart = true
	timer.start()

func _on_flicker_forge_light_timer_timeout():
	target_energy = randf_range(flicker_intensity_min, flicker_intensity_max)

func _process(delta):
	energy = lerp(energy, target_energy, transition_speed * delta)
