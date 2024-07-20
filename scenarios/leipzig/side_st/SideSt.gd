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
	
	Data.stats["location"] = "leipzig/side_st/SideSt"
	Data.save_game()
	
	$Audio.playing = true
	$Audio/Player.play("fade_in")
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false

# Buttons

func _on_inn_pressed():
	$TextBox/Outcome.text = "You enter the side door of the Gasthaus."
	next_scene = "res://scenarios/leipzig/inn/Inn.tscn"
	scene_outcome()
	
func _on_metalworkers_pressed():
	$TextBox/Outcome.text = "You walk down the lane to the metal workshops."
	next_scene = "res://scenarios/leipzig/metalworkers/Metalworkers.tscn"
	scene_outcome()

func _on_crafts_pressed():
	$TextBox/Outcome.text = "You enter the crafts district."
	next_scene = "res://scenarios/leipzig/crafts/Crafts.tscn"
	scene_outcome()

func _on_physicians_pressed():
	$TextBox/Outcome.text = "You enter the laneway of the city's physicians and alchemists."
	next_scene = "res://scenarios/leipzig/physicians/Physicians.tscn"
	scene_outcome()

func _on_docks_pressed():
	$TextBox/Outcome.text = "You continue down the side street to the docks."
	next_scene = "res://scenarios/leipzig/docks/Docks.tscn"
	scene_outcome()

func _on_main_st_pressed():
	$TextBox/Outcome.text = "You return to the main street."
	next_scene = "res://scenarios/leipzig/main_st/MainSt.tscn"
	scene_outcome()

func scene_outcome():
	$TextBox/Outcome.visible = true
	$Audio/Player.play("fade_out")
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
			texture = load("res://scenarios/leipzig/side_st/SideSt-WN.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/side_st/SideSt-WD.jpg")
			$FadePanel/Player.play("fade_in_light")
	else:
		if night:
			texture = load("res://scenarios/leipzig/side_st/SideSt-SN.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/side_st/SideSt-SD.jpg")
			$FadePanel/Player.play("fade_in_light")
	
func fade_in_text():
	$TextBox.visible = true
	$TextBox/Options/Inn.grab_focus()
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
