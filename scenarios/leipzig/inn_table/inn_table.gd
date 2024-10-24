extends TextureRect

@onready var pc1_data = Data.get_node("PC1").dict
@onready var pc2_data = Data.get_node("PC2").dict
@onready var pc3_data = Data.get_node("PC3").dict
@onready var pc4_data = Data.get_node("PC4").dict
@onready var pc5_data = Data.get_node("PC5").dict
@onready var party_data = Data.get_node("Party").dict
@onready var is_text_faded_in = true
var next_scene = null
var winter = false
var night = false

func _ready():
	Data.get_node("Party").shuffle_up_party()
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
	
	party_data["location"] = "res://scenarios/leipzig/inn_table/inn_table.tscn"
	Data.save_game()
	
	Main.get_node("Audio/SFX").stream = load("res://audio/sfx/group_walking.ogg")
	Main.get_node("Audio/SFX").playing = true
	Main.get_node("Audio/SFX/Player").play("fade_in")
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false
	
	# set text for intro depending on number of people in party
	if Main.party_count == 0:
		$TextBox/Intro.text = "Sitting at the inn one day you observe..."
		$TextBox/Options/Inn.visible = false
	elif Main.party_count == 1:
		$TextBox/Intro.text = "...Sitting alone at the inn table you observe..."
		$TextBox/Options/Inn.text = "...not much is happening at the inn, so you depart."
	elif Main.party_count == 2:
		$TextBox/Intro.text = ("You are seated at a table with a companion, discussing the "
			+ "future of the party. You observe...")
		$TextBox/Options/Inn.text = "...your companion is looking around, eager to leave."
	else:
		$TextBox/Intro.text = ("You are all seated at a table at the inn in deep conversation "
			+ "about the future of the party . You observe...")
		$TextBox/Options/Inn.text = "...your companions are looking around, eager to leave."
	
	# set options depending on how many are in the party
	if Main.pc1.visible:
		if Main.party_count > 1:
			$TextBox/Options/RetirePC1.text = ("..." + pc1_data["first_name"] 
			+ " motion that " + pc1_data["she_he"] 
			+ " needs to tell you something important.")
		else:
			$TextBox/Options/RetirePC1.visible = false
	else:
		$TextBox/Options/RetirePC1.visible = false
	
	if Main.pc2.visible:
		$TextBox/Options/RetirePC2.text = ("..." + pc2_data["first_name"] 
		+ " motion that " + pc2_data["she_he"] 
		+ " needs to tell you something important.")
	else:
		$TextBox/Options/RetirePC2.visible = false
	
	if Main.pc3.visible:
		$TextBox/Options/RetirePC3.text = ("..." + pc3_data["first_name"] 
		+ " motion that " + pc3_data["she_he"] 
		+ " needs to tell you something important.")
	else:
		$TextBox/Options/RetirePC3.visible = false
	
	if Main.pc4.visible:
		$TextBox/Options/RetirePC4.text = ("..." + pc4_data["first_name"] 
		+ " motion that " + pc4_data["she_he"] 
		+ " needs to tell you something important.")
		$TextBox/Options/RecruitPC.visible = false
	else:
		$TextBox/Options/RetirePC4.visible = false
	
	if Main.pc5.visible:
		$TextBox/Options/RetirePC5.text = ("..." + pc5_data["first_name"] 
		+ " motion that " + pc5_data["she_he"] 
		+ " needs to tell you something important.")
	else:
		$TextBox/Options/RetirePC5.visible = false
	
# Buttons
func _on_recruit_pc_pressed():
	$TextBox/Outcome.text = ("You beckon them over.")
	
	next_scene = "res://scenarios/aa_pc_create/pc_create_childhood.tscn"
	Main.return_scene = "res://scenarios/leipzig/inn_table/inn_table.tscn"
	scene_outcome()
	
func _on_retire_pc_1_pressed():
	$TextBox/Outcome.text = pc1_data["first_name"] + " begins to talk..."
	Data.get_node("Party").dict["pc_focus"] = "PC1"
	next_scene = "res://scenarios/aa_pc_retire/pc_retire_a.tscn"
	scene_outcome()
	
func _on_retire_pc_2_pressed():
	$TextBox/Outcome.text = pc2_data["first_name"] + " begins to talk..."
	Data.get_node("Party").dict["pc_focus"] = "PC2"
	next_scene = "res://scenarios/aa_pc_retire/pc_retire_a.tscn"
	scene_outcome()

func _on_retire_pc_3_pressed():
	$TextBox/Outcome.text = pc3_data["first_name"] + " begins to talk..."
	Data.get_node("Party").dict["pc_focus"] = "PC3"
	next_scene = "res://scenarios/aa_pc_retire/pc_retire_a.tscn"
	scene_outcome()

func _on_retire_pc_4_pressed():
	$TextBox/Outcome.text = pc4_data["first_name"] + " begins to talk..."
	Data.get_node("Party").dict["pc_focus"] = "PC4"
	next_scene = "res://scenarios/aa_pc_retire/pc_retire_a.tscn"
	scene_outcome()

func _on_retire_pc_5_pressed():
	$TextBox/Outcome.text = pc5_data["first_name"] + " begins to talk..."
	Data.get_node("Party").dict["pc_focus"] = "PC5"
	next_scene = "res://scenarios/aa_pc_retire/pc_retire_a.tscn"
	scene_outcome()

func _on_inn_pressed():
	$TextBox/Outcome.text = "You leave the table and return to the main room of the inn."
	next_scene = "res://scenarios/leipzig/inn/inn.tscn"
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
			texture = load("res://scenarios/leipzig/inn_table/inn_table.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/inn_table/inn_table.jpg")
			$FadePanel/Player.play("fade_in_light")
	else:
		if night:
			texture = load("res://scenarios/leipzig/inn_table/inn_table.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/inn_table/inn_table.jpg")
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
		
