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
	
	Data.get_node("Party").dict["location"] = "res://scenarios/leipzig/side_st/side_st.tscn"
	Data.save_game()
	
	Main.get_node("Audio/SFX").stream = load("res://audio/sfx/group_walking.ogg")
	Main.get_node("Audio/SFX").playing = true
	Main.get_node("Audio/SFX/Player").play("fade_in")
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false

# Buttons

func _on_inn_pressed():
	$TextBox/Outcome.text = "You enter the side door of the Gasthaus."
	next_scene = "res://scenarios/leipzig/inn/inn.tscn"
	scene_outcome()
	
func _on_metalworkers_pressed():
	$TextBox/Outcome.text = "You walk down the lane to the metal workshops."
	next_scene = "res://scenarios/leipzig/metal_st/metal_st.tscn"
	scene_outcome()

func _on_crafts_pressed():
	$TextBox/Outcome.text = "You enter the crafts district."
	next_scene = "res://scenarios/leipzig/crafts/crafts.tscn"
	scene_outcome()

func _on_physicians_pressed():
	$TextBox/Outcome.text = "You enter the laneway of the city's physicians and alchemists."
	next_scene = "res://scenarios/leipzig/physicians/physicians.tscn"
	scene_outcome()

func _on_docks_pressed():
	$TextBox/Outcome.text = "You continue down the side street to the docks."
	next_scene = "res://scenarios/leipzig/docks/docks.tscn"
	scene_outcome()

func _on_main_st_pressed():
	$TextBox/Outcome.text = "You return to the main street."
	next_scene = "res://scenarios/leipzig/main_st/main_st.tscn"
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
			texture = load("res://scenarios/leipzig/side_st/side_st_wn.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/side_st/side_st_wd.jpg")
			$FadePanel/Player.play("fade_in_light")
	else:
		if night:
			texture = load("res://scenarios/leipzig/side_st/side_st_sn.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/side_st/side_st_sd.jpg")
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
