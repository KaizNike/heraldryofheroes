extends TextureRect

@onready var fade_player: AnimationPlayer = get_node("FadePanel/FadePlayer")
@onready var text_player: AnimationPlayer = get_node("TextBox/TextPlayer")

@onready var is_text_faded_in = true

func _ready():
	Data.hour = 1
	Data.save_game()
	$TextBox/Time.text = "It is " + Data.get_bell_time()
	# $TextBox/Intro.text = "You are in Leipzig's Main Street. You decide to..."
	fade_in_scenery()
	await fade_player.animation_finished
	is_text_faded_in = false

# Buttons
#func _on_inn_button_down():
#	Main.goto_scene("res://scenarios/leipzig/inn/Inn.tscn")
func _on_gates_inside_button_down():
	Main.goto_scene("res://scenarios/leipzig/gates_inside/GatesInside.tscn")

# Click to reveal scenario text
func _unhandled_input(event):
	if event is InputEventMouseButton or InputEventKey and event.is_pressed():
		get_viewport().set_input_as_handled()
		if is_text_faded_in == false:
			fade_in_text()
			is_text_faded_in = true

# Fade in and out functions for scene changes.
func fade_in_scenery():
	$FadePanel.visible = true
	if Data.hour > 6 and Data.hour < 18:
		texture = load("res://scenarios/leipzig/main_st/MainStDay.jpg")
		fade_player.play("fade_in_light")
	else:
		texture = load("res://scenarios/leipzig/main_st/MainStNight.jpg")
		fade_player.play("fade_in_dark")
	
func fade_in_text():
	$TextBox.visible = true
	if Data.hour > 6 and Data.hour < 18:
		fade_player.play("fade_out_light")
		text_player.play("fade_in_text_dark")
	else:
		fade_player.play("fade_out_dark")
		text_player.play("fade_in_text_light")




