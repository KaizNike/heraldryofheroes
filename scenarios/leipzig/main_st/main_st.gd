extends TextureRect

@onready var is_text_faded_in = true
var next_scene = null
var winter = false
var night = false

func _ready():
	if Data.time["month"] > 2 and Data.time["month"] < 12:
		winter = false
		if Data.time["hour"] > 6 and Data.time["hour"] < 18:
			night = false
		else:
			night = true
	else:
		winter = true
		if Data.time["hour"] > 8 and Data.time["hour"] < 16:
			night = false
		else:
			night = true
	$TextBox/Time.text = "It is " + Data.get_bell_time()
	
	Data.get_node("Party").dict["location"] = "res://scenarios/leipzig/main_st/main_st.tscn"
	Data.save_game()
	
	Main.get_node("Audio/SFX").stream = load("res://audio/sfx/group_walking.ogg")
	Main.get_node("Audio/SFX").playing = true
	Main.get_node("Audio/SFX/Player").play("fade_in")
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false

# Buttons
func _on_inn_pressed():
	$TextBox/Outcome.text = "You enter the Gasthaus."
	next_scene = "res://scenarios/leipzig/inn/inn.tscn"
	scene_outcome()
	
func _on_latin_quarter_pressed():
	$TextBox/Outcome.text = "You head to the Latin Quarter."
	next_scene = "res://scenarios/leipzig/latin_qtr/latin_qtr.tscn"
	scene_outcome()

func _on_gate_inside_pressed():
	$TextBox/Outcome.text = "You walk across to the city gates."
	next_scene = "res://scenarios/leipzig/gate_inside/gate_inside.tscn"
	scene_outcome()

func _on_side_st_pressed():
	$TextBox/Outcome.text = "You walk down a side street."
	next_scene = "res://scenarios/leipzig/side_st/side_st.tscn"
	scene_outcome()

func _on_lane_pressed():
	$TextBox/Outcome.text = "You slip down a narrow lane."
	next_scene = "res://scenarios/leipzig/lane/lane.tscn"
	scene_outcome()

func _on_square_pressed():
	$TextBox/Outcome.text = "You enter the city square."
	next_scene = "res://scenarios/leipzig/square/square.tscn"
	scene_outcome()

func _on_market_pressed():
	$TextBox/Outcome.text = "You enter the market"
	next_scene = "res://scenarios/leipzig/market/market.tscn"
	scene_outcome()

func scene_outcome():
	Main.get_node("Audio/SFX/Player").play("fade_out")
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
			texture = load("res://scenarios/leipzig/main_st/main_st_wn.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/main_st/main_st_wd.jpg")
			$FadePanel/Player.play("fade_in_light")
	else:
		if night:
			texture = load("res://scenarios/leipzig/main_st/main_st_sn.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/main_st/main_st_sd.jpg")
			$FadePanel/Player.play("fade_in_light")
	
func fade_in_text():
	$TextBox.visible = true
	$TextBox/Options.get_child(0).grab_focus()
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
