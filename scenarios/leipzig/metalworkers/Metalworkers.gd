extends TextureRect

@onready var is_text_faded_in = true
var next_scene = null
var winter = false
var night = false

func _ready():
	Data.hour = 1
	if Data.time["month"] > 2 and Data.time["month"] < 12:
		winter = false
		if Data.hour > 6 and Data.hour < 18:
			night = false
		else:
			night = true
	else:
		winter = true
		if Data.hour > 8 and Data.hour < 16:
			night = false
		else:
			night = true
	$TextBox/Time.text = "It is " + Data.get_bell_time()
	
	Data.stats["location"] = "leipzig/metalworkers/Metalworkers"
	Data.save_game()
	
	$Audio.playing = true
	$Audio/Player.play("fade_in")
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false

# Buttons

func _on_side_st_pressed():
	$TextBox/Outcome.text = "You return to the side street."
	next_scene = "res://scenarios/leipzig/side_st/SideSt.tscn"
	scene_outcome()

func scene_outcome():
	$Audio/Player.play("fade_out")
	$TextBox/Outcome.visible = true
	var options : Array = $TextBox/Options.get_children()
	for i in options.size():
		options[i].disabled = true
		options[i].mouse_filter = MOUSE_FILTER_IGNORE

# Click to reveal scenario text
func _unhandled_input(event):
	if (event is InputEventMouseButton or InputEventKey) and event.is_pressed():
		get_viewport().set_input_as_handled()
		if is_text_faded_in == false:
			fade_in_text()
			is_text_faded_in = true
		elif next_scene != null:
			Main.goto_scene(next_scene)

# Fade in and out functions for scene changes.
func fade_in_scenery():
	$FadePanel.visible = true
	if winter:
		if night:
			texture = load("res://scenarios/leipzig/metalworkers/Metalworkers-WN.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/metalworkers/Metalworkers-WD.jpg")
			$FadePanel/Player.play("fade_in_light")
	else:
		if night:
			texture = load("res://scenarios/leipzig/metalworkers/Metalworkers-SN.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/metalworkers/Metalworkers-SD.jpg")
			$FadePanel/Player.play("fade_in_light")
	
func fade_in_text():
	$TextBox.visible = true
	$TextBox/Options/SideSt.grab_focus()
	if winter:
		if night:
			$FadePanel/Player.play("fade_out_dark")
			$TextBox/Player.play("fade_in_text_light")
		else:
			$FadePanel/Player.play("fade_out_light")
			$TextBox/Player.play("fade_in_text_dark")
	else:
		if night:
			$FadePanel/Player.play("fade_out_dark")
			$TextBox/Player.play("fade_in_text_light")
		else:
			$FadePanel/Player.play("fade_out_light")
			$TextBox/Player.play("fade_in_text_dark")
