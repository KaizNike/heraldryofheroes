extends TextureRect


# Declare member variables
@onready var fade_player: AnimationPlayer = get_node("FadePanel/FadePlayer")
@onready var text_player: AnimationPlayer = get_node("TextBox/TextPlayer")
@onready var audio_player: AnimationPlayer = get_node("Audio/AudioPlayer")
#is_text_faded_in is set true here and then set false after the fade in animation
#this allows correct sequencing of the panel fade in, then text fade in
@onready var is_text_faded_in = true
@onready var next_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Data.time = 1
	Data.stats["location"] = "leipzig/inn/Inn"
	Data.save_game()
	$Audio.play()
	audio_player.play("fade_in_music")
	$TextBox/Time.text = "It is " + Data.get_bell_time()
	fade_in_scenery()
	await fade_player.animation_finished
	is_text_faded_in = false
	
	#if Data.get_node("PC1").dict["first_name"] != null:
		#get_node("TextBox/Options/DismissPC1").text = "...dismiss " + Data.get_node("PC1").dict["first_name"] + " from the party."
	#if Data.get_node("PC2").dict["first_name"] != null:
		#get_node("TextBox/Options/DismissPC2").text = "...dismiss " + Data.get_node("PC2").dict["first_name"] + " from the party."
	#if Data.get_node("PC3").dict["first_name"] != null:
		#get_node("TextBox/Options/DismissPC3").text = "...dismiss " + Data.get_node("PC3").dict["first_name"] + " from the party."
	#if Data.get_node("PC4").dict["first_name"] != null:
		#get_node("TextBox/Options/DismissPC4").text = "...dismiss " + Data.get_node("PC4").dict["first_name"] + " from the party."

# Buttons
func _on_main_st_pressed():
	$TextBox/Outcome.text = "You walk out the main door to the main street."
	next_scene = "res://scenarios/leipzig/main_st/MainSt.tscn"
	scene_outcome()

func scene_outcome():
	$TextBox/Outcome.visible = true
	audio_player.play("fade_out_music")
	var options : Array = $TextBox/Options.get_children()
	for i in options.size():
		options[i].disabled = true
		options[i].mouse_filter = MOUSE_FILTER_IGNORE

#func _on_recruit_pc_button_down():
	##create new player character and write their stats to data nodes and place in next available pc box
	#if Main.get_node("HBox/Party/PC1Frame/PC1").visible == false:
		#Data.new_player("PC1")
		#Main.get_node("HBox/Party/PC1Frame/PC1").update_box("PC1")
	#elif Main.get_node("HBox/Party/PC2Frame/PC2").visible == false:
		#Data.new_player("PC2")
		#Main.get_node("HBox/Party/PC2Frame/PC2").update_box("PC2")
	#elif Main.get_node("HBox/Party/PC3Frame/PC3").visible == false:
		#Data.new_player("PC3")
		#Main.get_node("HBox/Party/PC3Frame/PC3").update_box("PC3")
	#elif Main.get_node("HBox/Party/PC4Frame/PC4").visible == false:
		#Data.new_player("PC4")
		#Main.get_node("HBox/Party/PC4Frame/PC4").update_box("PC4")
	#
	#Main.goto_scene("res://scenarios/leipzig/inn/Inn.tscn")
	
#func _on_dismiss_pc_1_button_down():
	#Main.pc_button_hide("HBox/Party/PC1Frame/PC1")
	#Data.get_node("PC1").new_dict()
	#Main.goto_scene("res://scenarios/leipzig/inn/Inn.tscn")
	

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
		texture = load("res://scenarios/leipzig/inn/inn_day.jpg")
		fade_player.play("fade_in_light")
	else:
		texture = load("res://scenarios/leipzig/inn/inn_night.jpg")
		fade_player.play("fade_in_dark")
	
func fade_in_text():
	$TextBox.visible = true
	$TextBox/Options/MainSt.grab_focus()
	if Data.time > 6 and Data.time < 18:
		fade_player.play("fade_out_light")
		text_player.play("fade_in_text_dark")
	else:
		fade_player.play("fade_out_dark")
		text_player.play("fade_in_text_light")

