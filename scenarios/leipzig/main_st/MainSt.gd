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
	
	Data.stats["location"] = "leipzig/main_st/MainSt"
	Data.save_game()
	
	$Audio.playing = true
	$Audio/Player.play("fade_in")
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false

# Buttons
func _on_inn_pressed():
	$TextBox/Outcome.text = "You enter the Gasthaus."
	next_scene = "res://scenarios/leipzig/inn/Inn.tscn"
	scene_outcome()
	
func _on_latin_quarter_pressed():
	$TextBox/Outcome.text = "You head to the Latin Quarter."
	next_scene = "res://scenarios/leipzig/latin_quarter/LatinQuarter.tscn"
	scene_outcome()

func _on_gate_inside_pressed():
	$TextBox/Outcome.text = "You walk across to the city gates."
	next_scene = "res://scenarios/leipzig/gate_inside/GateInside.tscn"
	scene_outcome()

func _on_side_st_pressed():
	$TextBox/Outcome.text = "You walk down a side street."
	next_scene = "res://scenarios/leipzig/side_st/SideSt.tscn"
	scene_outcome()

func _on_lane_pressed():
	$TextBox/Outcome.text = "You slip down a narrow lane."
	next_scene = "res://scenarios/leipzig/lane/Lane.tscn"
	scene_outcome()

func _on_square_pressed():
	$TextBox/Outcome.text = "You enter the city square."
	next_scene = "res://scenarios/leipzig/square/Square.tscn"
	scene_outcome()

func _on_market_pressed():
	$TextBox/Outcome.text = "You enter the market"
	next_scene = "res://scenarios/leipzig/market/Market.tscn"
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
			texture = load("res://scenarios/leipzig/main_st/MainSt-WN.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/main_st/MainSt-WD.jpg")
			$FadePanel/Player.play("fade_in_light")
	else:
		if night:
			texture = load("res://scenarios/leipzig/main_st/MainSt-SN.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/main_st/MainSt-SD.jpg")
			$FadePanel/Player.play("fade_in_light")
	
func fade_in_text():
	$TextBox.visible = true
	$TextBox/Options/GateInside.grab_focus()
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
