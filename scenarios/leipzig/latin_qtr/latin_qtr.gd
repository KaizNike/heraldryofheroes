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
	
	Data.get_node("Party").dict["location"] = "res://scenarios/leipzig/latin_qtr/latin_qtr.tscn"
	Data.save_game()
	
	Main.get_node("Audio/SFX").stream = load("res://audio/sfx/group_walking.ogg")
	Main.get_node("Audio/SFX").playing = true
	Main.get_node("Audio/SFX/Player").play("fade_in")
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false

# Buttons

func _on_university_pressed():
	$TextBox/Outcome.text = "You enter the university."
	next_scene = "res://scenarios/leipzig/university/university.tscn"
	scene_outcome()

func _on_church_pressed():
	$TextBox/Outcome.text = "You enter the church."
	next_scene = "res://scenarios/leipzig/church/church.tscn"
	scene_outcome()
	
func _on_cathedral_pressed():
	$TextBox/Outcome.text = "You return the cathedral."
	next_scene = "res://scenarios/leipzig/cathedral/cathedral.tscn"
	scene_outcome()

func _on_monastery_pressed():
	$TextBox/Outcome.text = "You enter the monastery."
	next_scene = "res://scenarios/leipzig/monastery/monastery.tscn"
	scene_outcome()

func _on_garden_pressed():
	$TextBox/Outcome.text = "You enter a garden which borders the university, church and monastery."
	next_scene = "res://scenarios/leipzig/garden/garden.tscn"
	scene_outcome()

func _on_square_pressed():
	$TextBox/Outcome.text = "You enter a side street heading to the city square and Rathaus."
	next_scene = "res://scenarios/leipzig/square/square.tscn"
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
			texture = load("res://scenarios/leipzig/latin_qtr/latin_qtr_wn.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/latin_qtr/latin_qtr_wd.jpg")
			$FadePanel/Player.play("fade_in_light")
	else:
		if night:
			texture = load("res://scenarios/leipzig/latin_qtr/latin_qtr_sn.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/latin_qtr/latin_qtr_sd.jpg")
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


