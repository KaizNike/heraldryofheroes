extends TextureRect

@onready var party_dict = Data.get_node("Party").dict
@onready var is_text_faded_in = true
var next_scene = null
var pc_num
var pc_data

func _ready():
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false
	
	# this variable, pc_focus, tracks which pc is active in a series of scenes
	party_dict["pc_focus"] = "PC1"
	pc_num = party_dict["pc_focus"]
	pc_data = Data.get_node(pc_num)
	# creates a random new pc then updates the stats box
	pc_data.create_pc()
	Main.get_node("HBox/Party/" + pc_num + "Frame/" + pc_num).update_box(pc_num)
	var approx_age : int = pc_data.dict["age"] / 5
	approx_age *= 5
	
	$TextBox/Intro.text = (pc_data.dict["first_name"] 
		+ " sits at the inn table and ponders the emblem drawn
		on the piece of paper in front of "
		+ pc_data.dict["her_him"] + "...")
	
# Buttons
func _on_heraldry_1_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry1.png"
	scene_outcome()
func _on_heraldry_2_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry2.png"
	scene_outcome()
func _on_heraldry_3_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry3.png"
	scene_outcome()
func _on_heraldry_4_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry4.png"
	scene_outcome()
func _on_heraldry_5_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry5.png"
	scene_outcome()
func _on_heraldry_6_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry6.png"
	scene_outcome()
func _on_heraldry_7_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry7.png"
	scene_outcome()
func _on_heraldry_8_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry8.png"
	scene_outcome()
func _on_heraldry_9_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry9.png"
	scene_outcome()
func _on_heraldry_10_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry10.png"
	scene_outcome()
func _on_heraldry_11_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry11.png"
	scene_outcome()
func _on_heraldry_12_pressed():
	party_dict["heraldry"] = "res://images/heraldry/heraldry12.png"
	scene_outcome()
	
func scene_outcome():
	$TextBox/Outcome.text = ("Tracing a finger around it "
		+ pc_data.dict["she_he"] + " wonders what it means "
		+ "and the history behind it, leading "
		+ pc_data.dict["her_him"] + " to consider "
		+ pc_data.dict["her_his"] + " own past.")
	next_scene = "res://scenarios/aa_pc_create/pc_create_childhood.tscn"
	$TextBox/Outcome.visible = true
	$TextBox/Options/Row1.visible = false
	$TextBox/Options/Row2.visible = false
	$TextBox/Options/Row3.visible = false

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
	texture = load("res://images/interface/blue_background.jpg")
	$FadePanel/Player.play("fade_in_dark")
	
func fade_in_text():
	$TextBox.visible = true
	$TextBox/Options/Row1.get_child(0).grab_focus()
	$FadePanel/Player.play("fade_out_dark")
	$TextBox/Player.play("fade_in_text_gold")

