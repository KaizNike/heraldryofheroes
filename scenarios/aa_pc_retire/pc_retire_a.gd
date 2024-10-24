extends TextureRect

@onready var is_text_faded_in = true
var next_scene = null
var pc
var pc_name

func _ready():
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false
	
	pc = Data.pc_focus
	pc_name = Data.get_node(pc).dict["first_name"]
	
func _on_retire_pressed():
	Main.get_node("HBox/Party/" + pc + "Frame/" + pc).visible = false
	Data.get_node(pc).clear_dict()
	Main.goto_scene("res://scenarios/leipzig/inn_table/InnTable.tscn")

func _on_inn_table_pressed():
	$TextBox/Outcome.text = pc_name + "'s tale goes nowhere in particular and eventually the group resumes its conversation."
	next_scene = "res://scenarios/leipzig/inn_table/InnTable.tscn"
	scene_outcome()
	
func scene_outcome():
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
	texture = load("res://images/interface/blue_background.jpg")
	$FadePanel/Player.play("fade_in_dark")
	
func fade_in_text():
	$TextBox.visible = true
	$TextBox/Options/InnTable.grab_focus()
	$FadePanel/Player.play("fade_out_dark")
	$TextBox/Player.play("fade_in_text_gold")
		
