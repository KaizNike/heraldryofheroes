extends TextureRect
@onready var party_dict = Data.get_node("Party").dict
@onready var is_text_faded_in = true
var next_scene = null
var pc_num
var pc_data
var upgrades1 : Array = []
var upgrades2 : Array = []
var upgrades3 : Array = []
var upgrades4 : Array = []
var outcome_text1: String
var outcome_text2: String
var outcome_text3: String
var outcome_text4: String

func _ready():
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false
	pc_num = party_dict["pc_focus"]
	pc_data = Data.get_node(pc_num)
	Main.get_node("HBox/Party/" + pc_num + "Frame/" + pc_num).update_box(pc_num)

	$TextBox/Intro.text = (pc_data.dict["first_name"] + " then thinks about "
		+ pc_data.dict["her_his"] + " father, who...")
	
	if party_dict["prev_outcome"] == "rural":
		$TextBox/Options/Father1.text = "...was a farmer growing crops and raising livestock."
		upgrades1 = ["polearm","impact","woodwise","riding"]
		outcome_text1 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father2.text = "...forraged and made medicine from herbs."
		upgrades2 = ["alchemy","impact","woodwise","woodwise","riding"]
		outcome_text2 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father3.text = "...repaired tools for the farmers."
		upgrades3 = ["polearm","polearm","polearm","impact","woodwise","woodwise","riding","riding"]
		outcome_text3 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father4.text = "...devoted her life to the church."
		upgrades4 = ["religion","religion","religion","righteous","righteous","righteous","read_write"]
		outcome_text4 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
	elif party_dict["prev_outcome"] == "urban":
		$TextBox/Options/Father1.text = "...worked at a market stall selling vegetables."
		upgrades1 = ["streetwise","streetwise","streetwise","speak","speak","speak","trade"]
		outcome_text1 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father2.text = "...brewed beer, wine and other concoctions at the tavern."
		upgrades2 = ["alchemy","streetwise","speak","trade","heal","artifice"]
		outcome_text2 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father3.text = "...repaired wagons for traveling merchants."
		upgrades3 = ["impact","artifice","artifice","artifice","trade","speak"]
		outcome_text3 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father4.text = "...worked at the docks."
		upgrades4 = ["strength","speak","trade","streetwise","streetwise"]
		outcome_text4 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
	elif party_dict["prev_outcome"] == "crafts":
		$TextBox/Options/Father1.text = "...weaved cloth and sewed clothing."
		upgrades1 = ["artifice","artifice","artifice","speak","streetwise"]
		outcome_text1 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father2.text = "...fabricated locks and keys."
		upgrades2 = ["artifice","artifice","artifice","artifice","alchemy","trade"]
		outcome_text2 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father3.text = "...made saddles and other equipment for horses."
		upgrades3 = ["artifice","artifice","artifice","riding","riding","woodwise"]
		outcome_text3 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father4.text = "...worked metal into weapons."
		upgrades4 = ["artifice","artifice","artifice","strength","endurance","trade"]
		outcome_text4 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
	elif party_dict["prev_outcome"] == "merchant":
		$TextBox/Options/Father1.text = "...managed the money for the business."
		upgrades1 = ["trade","trade","trade","speak","read_write","read_write","read_write",
			"latin"]
		outcome_text1 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father2.text = "...read and studied widely."
		upgrades2 = ["alchemy","alchemy","read_write","read_write","read_write","latin","latin",
			"religion","religion"]
		outcome_text2 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father3.text = "...negotiated contracts with nobility and the church."
		upgrades3 = ["trade","trade","trade","speak","speak","speak","latin","latin","latin"]
		outcome_text3 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )
		$TextBox/Options/Father4.text = "...was a skilled healer and apothecary."
		upgrades4 = ["trade","speak","latin","read_write","alchemy","alchemy","heal",
			"heal","heal"]
		outcome_text4 = ( "He taught " + pc_data.dict["first_name"]
			+ " much about that way of life." )

# Buttons
func _on_father_1_pressed():
	for i in upgrades1:
		pc_data.dict[i] += 1
	$TextBox/Outcome.text = outcome_text1
	scene_outcome()

func _on_father_2_pressed():
	for i in upgrades2:
		pc_data.dict[i] += 1
	$TextBox/Outcome.text = outcome_text2
	scene_outcome()

func _on_father_3_pressed():
	for i in upgrades3:
		pc_data.dict[i] += 1
	$TextBox/Outcome.text = outcome_text3
	scene_outcome()

func _on_father_4_pressed():
	for i in upgrades4:
		pc_data.dict[i] += 1
	$TextBox/Outcome.text = outcome_text4
	scene_outcome()
	
func scene_outcome():
	if pc_data.dict["age"] < 20:
		next_scene = "res://scenarios/leipzig/inn_table/inn_table.tscn"
	else:
		next_scene = "res://scenarios/aa_pc_create/pc_create_first_job.tscn"
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
	$TextBox/Options.get_child(0).grab_focus()
	$FadePanel/Player.play("fade_out_dark")
	$TextBox/Player.play("fade_in_text_gold")
		

