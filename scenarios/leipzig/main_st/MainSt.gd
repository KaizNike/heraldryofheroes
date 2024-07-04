extends TextureRect

@onready var fade_player: AnimationPlayer = get_node("FadePanel/FadePlayer")
@onready var text_player: AnimationPlayer = get_node("TextBox/TextPlayer")
@onready var audio_player: AnimationPlayer = get_node("Audio/AudioPlayer")
@onready var is_text_faded_in = true
@onready var next_scene = null

func _ready():
	Data.time = 1
	Data.stats["location"] = "leipzig/main_st/MainSt"
	Data.save_game()
	$Audio.play()
	audio_player.play("fade_in_music")
	$TextBox/Time.text = "It is " + Data.get_bell_time()
	fade_in_scenery()
	await fade_player.animation_finished
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
	audio_player.play("fade_out_music")
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
	if Data.time > 6 and Data.time < 18:
		texture = load("res://scenarios/leipzig/main_st/MainStDay.jpg")
		fade_player.play("fade_in_light")
	else:
		texture = load("res://scenarios/leipzig/main_st/MainStNight.jpg")
		fade_player.play("fade_in_dark")
	
func fade_in_text():
	$TextBox.visible = true
	$TextBox/Options/GateInside.grab_focus()
	if Data.time > 6 and Data.time < 18:
		fade_player.play("fade_out_light")
		text_player.play("fade_in_text_dark")
	else:
		fade_player.play("fade_out_dark")
		text_player.play("fade_in_text_light")
