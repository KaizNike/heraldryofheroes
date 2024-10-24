extends TextureRect

@onready var party_dict = Data.get_node("Party").dict
@onready var is_text_faded_in = true
var next_scene = null
var pc_num
var pc_data
var upgrades: Array
var downgrades: Array

func _ready():
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false
	pc_num = party_dict["pc_focus"]
	pc_data = Data.get_node(pc_num)
	Main.get_node("HBox/Party/" + pc_num + "Frame/" + pc_num).update_box(pc_num)
	$TextBox/Intro.text = (pc_data.dict["first_name"] + " thinks back on " 
		+ pc_data.dict["her_his"] + " childhood...")
	$TextBox/Options/Rural.text = "...as a rural peasant."
	$TextBox/Options/Urban.text = "...as an urban commoner."
	$TextBox/Options/Crafts.text = "...in a family belonging to one of the crafts guilds."
	$TextBox/Options/Merchant.text = "...in a family of wealthy merchants."
	
# Buttons
func _on_rural_pressed():
	party_dict["prev_outcome"] = "rural"
	if ( pc_data.dict["strength"] + pc_data.dict["endurance"] 
	+ pc_data.dict["polearm"] + pc_data.dict["woodwise"]
	) > randi()%200:
		$TextBox/Outcome.text = ( "Life on the farm was hard work and "
		+ pc_data.dict["first_name"] + " grew up to be strong and hardy, skilled with hand tools, "
		+ "and knowledgeable of the outdoors and animals." )
		upgrades = ["strength_max","endurance_max","polearm","impact","blade","flail","bow",
			"woodwise","riding"]
		downgrades = ["read_write","latin","speak","charisma_max","intelligence_max",
			"religion","righteous"]
	else:
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " struggled with the grueling demands "
			+ "of farm life, frequently falling ill and spending more time confined to bed than working "
			+ "the fields. Despite these challenges, " + pc_data.dict["her_his"] + " sharp intellect "
			+ "and genuine interest in the church caught the attention of the local priest, who saw "
			+ "potential in " + pc_data.dict["her_him"] + " and decided to take a personal interest in "
			+ pc_data.dict["her_his"] + " development." )
		upgrades = ["intelligence_max","perception_max","religion","righteous","heal","latin","read_write"]
		downgrades = ["strength_max","endurance_max","blade","impact","polearm","flail","gun","streetwise"]
	scene_outcome()

func _on_urban_pressed():
	party_dict["prev_outcome"] = "urban"
	upgrades = ["strength_max","endurance_max","endurance_max","agility_max","perception_max",
		"polearm","impact","blade","throw","speak","speak","streetwise","streetwise",
		"streetwise","artifice","trade","trade"]
	for i in upgrades:
		pc_data.dict[i] += 5
	$TextBox/Outcome.text = ( "Growing up in the busy city made "
		+ pc_data.dict["first_name"]
		+ " savvy about the ways of people, how to speak persuasively and negotiate, and how to find "
		+ pc_data.dict["her_his"] + " way through the city's streets and laneways." )
	scene_outcome()

func _on_crafts_pressed():
	party_dict["prev_outcome"] = "crafts"
	upgrades = ["strength_max","endurance_max","agility_max","agility_max","perception_max",
		"intelligence_max","impact","impact","impact","blade","blade","gun","streetwise",
		"woodwise","artifice","artifice","artifice","artifice","alchemy","alchemy","riding"]
	for i in upgrades:
		pc_data.dict[i] += 5
	$TextBox/Outcome.text = ( "Raised amongst a family of artisans "
		+ pc_data.dict["first_name"]
		+ " became expert with crafting and understanding how mechanisms work." )
	scene_outcome()

func _on_merchant_pressed():
	party_dict["prev_outcome"] = "merchant"
	upgrades = ["charisma_max","perception_max","intelligence_max","blade","streetwise","trade",
		"religion","righteous","latin","read_write","artifice","alchemy","riding"]
	for i in upgrades:
		pc_data.dict[i] += 5
	$TextBox/Outcome.text = ( "Born into a wealthy merchant family "
		+ pc_data.dict["first_name"]
		+ " was priveleged to receive an education and to learn how to manage "
		+ pc_data.dict["her_his"] + " family's business." )
	scene_outcome()
	
func scene_outcome():
	for i in upgrades:
		pc_data.dict[i] += 5
	for j in downgrades:
		pc_data.dict[j] -= 5
	next_scene = "res://scenarios/aa_pc_create/pc_create_mother.tscn"
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
		

