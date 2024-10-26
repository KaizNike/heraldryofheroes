extends TextureRect

@onready var party_dict = Data.get_node("Party").dict
@onready var is_text_faded_in = true
var next_scene = null
var pc_num
var pc_data
var jobs_available: Array = ["vagabond"]
var upgrades: Array = []
var downgrades: Array = []

func _ready():
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false
	pc_num = party_dict["pc_focus"]
	pc_data = Data.get_node(pc_num)
	Main.get_node("HBox/Party/" + pc_num + "Frame/" + pc_num).update_box(pc_num)

	$TextBox/Intro.text = "Upon leaving home " + pc_data.dict["she_he"] + "..."
	
	set_jobs()
	
	if jobs_available.has("vagabond"):
		$TextBox/Options/Vagabond.visible = true
		$TextBox/Options/Vagabond.text = ( "...wandered the land and worked a variety of jobs "
			+ "whenever opportunities arose." )
	
	if jobs_available.has("guard"):
		jobs_available.erase("guard")
		$TextBox/Options/Guard.visible = true
		$TextBox/Options/Guard.text = "...enlisted as a soldier."
	
	if jobs_available.has("smith"):
		jobs_available.erase("smith")
		$TextBox/Options/Smith.visible = true
		$TextBox/Options/Smith.text = "...apprenticed to a blacksmith."
	
	if jobs_available.has("hunter"):
		jobs_available.erase("hunter")
		$TextBox/Options/Hunter.visible = true
		$TextBox/Options/Hunter.text = "...joined a team of hunters catching wild game in the woods."
		
	if jobs_available.has("physician"):
		jobs_available.erase("physician")
		$TextBox/Options/Physician.visible = true
		$TextBox/Options/Physician.text = "...assisted a physician treating injuries and ailments."
	
	if jobs_available.has("church"):
		jobs_available.erase("church")
		$TextBox/Options/Church.visible = true
		if pc_data.dict["sex"] == "female":
			$TextBox/Options/Church.text = "...joined a monastery as a nun."
		else:
			$TextBox/Options/Church.text = "...joined a monastery as a monk."
	
	if jobs_available.has("student"):
		jobs_available.erase("student")
		$TextBox/Options/Student.visible = true
		$TextBox/Options/Student.text = "...studied at university."
	
	if jobs_available.has("merchant"):
		jobs_available.erase("merchant")
		$TextBox/Options/Merchant.visible = true
		$TextBox/Options/Merchant.text = "...helped at a market stall belonging to a wealthy merchant."

# Buttons
func _on_vagabond_pressed():
	if ( pc_data.dict["endurance_max"] + pc_data.dict["charisma_max"] + pc_data.dict["polearm"]
	+ pc_data.dict["impact"] + pc_data.dict["bow"] + pc_data.dict["artifice"] + pc_data.dict["speak"]
	+ pc_data.dict["trade"] + pc_data.dict["streetwise"] + pc_data.dict["woodwise"] + pc_data.dict["riding"]
	) > randi()%550:
		party_dict["prev_outcome"] = "vagabond success"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " spent five carefree years "
			+ "traveling, sometimes alone, sometimes with merchants, finding employment in "
			+ "a variety of roles from laboring at the docks to selling produce at a market stall." )
		upgrades = ["endurance_max","charisma_max","polearm","blade","shield","gun"]
		downgrades = ["intelligence_max","perception_max","read_write","latin","religion",
			"righteous","gun"]
	else:
		party_dict["prev_outcome"] = "vagabond failure"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " barely survived during five long "
			+ "years on the road, resorting first to begging, then thieving, and eventually joining "
			+ "a group of bandits raiding merchants traveling on the highways." ) 
		upgrades = ["perception_max","agility_max","blade","bow","throw","gun","woodwise","streetwise"]
		downgrades = ["strength_max","intelligence_max","charisma_max","read_write","latin"]
	scene_outcome()

func _on_guard_pressed():
	if ( pc_data.dict["blade"] + pc_data.dict["polearm"] + pc_data.dict["shield"]
	+ pc_data.dict["gun"] + pc_data.dict["strength_max"] + pc_data.dict["endurance_max"]
	) > randi()%300:
		party_dict["prev_outcome"] = "guard success"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " excelled as a soldier, "
			+ "greatly improving combat skills and physical prowess." )
		upgrades = ["strength_max","endurance_max","agility_max","polearm","blade","shield","gun"]
		downgrades = ["intelligence_max","charisma_max","read_write","latin"]
	else:
		party_dict["prev_outcome"] = "guard failure"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " had a miserable and defeating "
			+ "experience in the guard, being bullied and beaten by other recruits, "
			+ "and turned to the word of God for aid in getting through." ) 
		upgrades = ["perception_max","agility_max","shield","read_write","religion","righteous","heal"]
		downgrades = ["intelligence_max","charisma_max","read_write","latin"]
	scene_outcome()

func _on_smith_pressed():
	if ( pc_data.dict["impact"] + pc_data.dict["artifice"]
	+ pc_data.dict["strength_max"] + pc_data.dict["agility_max"]
	) > randi()%200:
		party_dict["prev_outcome"] = "smith success"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " learned the smithing trade quickly "
			+ "and was well liked by " + pc_data.dict["her_his"] + " master." )
		upgrades = ["strength_max","agility_max","impact","impact","artifice","artifice"]
		downgrades = ["intelligence_max","speak","read_write","latin"]
	else:
		party_dict["prev_outcome"] = "smith failure"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " had a cantankerous master, "
			+ "who was a poor teacher of the craft, and instead spent most of "
			+ pc_data.dict["her_his"] + " time cleaning the workshop, "
			+ "fetching materials and dealing with customers." )
		upgrades = ["trade","speak","riding","streetwise","woodwise","alchemy","read_write"]
		downgrades = ["polearm","blade","shield","gun","bow","throw","religion","righteous"]
	scene_outcome()

func _on_hunter_pressed():
	if ( pc_data.dict["throw"] + pc_data.dict["bow"]
	+ pc_data.dict["riding"] + pc_data.dict["woodwise"]
	+ pc_data.dict["agility_max"] + pc_data.dict["perception_max"]
	) > randi()%200:
		party_dict["prev_outcome"] = "hunter success"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " excelled as a hunter, "
			+ "being steady on horseback and having fine aim with bow and arrow." )
		upgrades = ["blade","polearm","bow","throw","woodwise","riding","agility_max","perception_max"]
		downgrades = ["charisma_max","speak","streetwise","alchemy","read_write","latin","religion","righteous"]
	else:
		party_dict["prev_outcome"] = "hunter failure"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " was poorly suited as a hunter, "
			+ "and instead was put in charge of skinning, tanning hides and stitching leather "
			+ "equipment, as well as trading these goods with merchants." )
		upgrades = ["riding","artifice","trade","speak","perception_max","blade"]
		downgrades = ["polearm","shield","gun","agility_max","charisma_max","latin","religion"]
	scene_outcome()

func _on_physician_pressed():
	if ( pc_data.dict["heal"] + pc_data.dict["alchemy"]
	+ pc_data.dict["intelligence_max"] + pc_data.dict["perception_max"]
	) > randi()%200:
		party_dict["prev_outcome"] = "physician success"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " was well liked by the physician, "
			+ "being astute and knowledgeable of healing and medicine" )
		upgrades = ["intelligence_max","perception_max","alchemy","alchemy","heal","heal"
			,"read_write","latin"]
		downgrades = ["strength_max","endurance_max","blade","polearm","impact","shield","bow"
			,"throw","gun"]
	else:
		party_dict["prev_outcome"] = "physician failure"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " was treated as inferior by "
			+ pc_data.dict["her_his"] + " master, and was given the task of copying texts, "
			+ "on medicine and alchemy, much of which was written in Latin." )
		upgrades = ["intelligence_max","alchemy","healing","religion","righteous"
			,"read_write","latin","speak"]
		downgrades = ["strength_max","endurance_max","blade","polearm","impact","shield","bow"
			,"throw","gun"]
	scene_outcome()
	
func _on_church_pressed():
	if ( pc_data.dict["endurance_max"] + pc_data.dict["flail"] + pc_data.dict["religion"]
	+ pc_data.dict["righteous"] + pc_data.dict["perception_max"]
	) > randi()%250:
		party_dict["prev_outcome"] = "church success"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " found "
			+ pc_data.dict["her_his"] + " time at the monastery enriching, bringing "
			+ pc_data.dict["her_him"] + " closer to God." )
		upgrades = ["endurance_max","perception_max","religion","religion","righteous"
			,"righteous","flail"]
		downgrades = ["strength_max","charisma_max","blade","shield","bow","gun",]
	else:
		party_dict["prev_outcome"] = "church failure"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " found "
			+ pc_data.dict["her_his"] + " time at the monastery frustrating, making "
			+ pc_data.dict["her_him"] + " cynical of the church. Instead " 
			+ pc_data.dict["she_he"] + " read widely and became interested "
			+ "in the workings of the world." )
		upgrades = ["read_write","latin","alchemy","heal","artifice","speak"]
		downgrades = ["strength_max","charisma_max","blade","shield","bow","gun",]
	scene_outcome()
	
func _on_student_pressed():
	if ( pc_data.dict["latin"] + pc_data.dict["read_write"]
	+ pc_data.dict["intelligence_max"] + pc_data.dict["perception_max"]
	) > randi()%200:
		party_dict["prev_outcome"] = "student success"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + "'s intellect made "
			+ pc_data.dict["her_him"] + " a high achieving student and "
			+ pc_data.dict["she_he"] + " made connections with aristocracy." )
		upgrades = ["latin","read_write","alchemy","heal","speak","religion","righteous"]
		downgrades = ["strength_max","endurance_max","polearm","blade","shield","bow","throw"
			,"gun","woodwise"]
	else:
		party_dict["prev_outcome"] = "student failure"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " found university challenging and "
			+ pc_data.dict["she_he"] + " spent much of " + pc_data.dict["her_his"] 
			+ " time riding out of the city into the woods, to clear "
			+ pc_data.dict["her_his"] + " head." )
		upgrades = ["riding","woodwise","bow","read_write","alchemy","agility_max","endurance_max"]
		downgrades = ["shield","speak","flail","streetwise","strength_max"]
	scene_outcome()
	
func _on_merchant_pressed():
	if ( pc_data.dict["speak"] + pc_data.dict["trade"] + pc_data.dict["perception_max"]
	+ pc_data.dict["streetwise"] + pc_data.dict["charisma_max"]
	) > randi()%250:
		party_dict["prev_outcome"] = "merchant success"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " thrived in the market"
			+ ", having a gift for winning people over and earning their trust, and"
			+ pc_data.dict["she_he"] + " made connections with famous merchant families." )
		upgrades = ["charisma_max","charisma_max","speak","speak","trade","trade","streetwise"
			,"read_write"]
		downgrades = ["polearm","blade","impact","flail","shield","gun"]
	else:
		party_dict["prev_outcome"] = "merchant failure"
		$TextBox/Outcome.text = ( pc_data.dict["first_name"] + " was overwhelmed in the bustling "
			+ "market environment and customers found " + pc_data.dict["her_him"]
			+ " unconvincing, so " + pc_data.dict["she_he"]
			+ " performed labouring duties, carting goods across the city "
			+ ", to and from the docks.")
		upgrades = ["strength_max","endurance_max","streetwise","trade","polearm","throw"]
		downgrades = ["blade","shield","gun","bow","religion","righteous"]
	scene_outcome()

func scene_outcome():
	for i in upgrades:
		pc_data.dict[i] += 5
	for j in downgrades:
		pc_data.dict[j] -= 5
	
	if pc_data.dict["age"] < 25:
		next_scene = "res://scenarios/leipzig/inn_table/inn_table.tscn"
	else:
		next_scene = "res://scenarios/aa_pc_create/pc_start_f.tscn"
	$TextBox/Outcome.text += party_dict["prev_outcome"]
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
		
func set_jobs():
	if ( pc_data.dict["strength"] + pc_data.dict["endurance"] + pc_data.dict["blade"]
	+ pc_data.dict["polearm"] + pc_data.dict["impact"] + pc_data.dict["bow"] + pc_data.dict["gun"]
	) > 210:
		jobs_available.append("guard")
	
	if ( pc_data.dict["strength"] + pc_data.dict["endurance"] + pc_data.dict["agility"]
	+ pc_data.dict["perception"] + pc_data.dict["impact"] + pc_data.dict["artifice"]
	) > 180:
		jobs_available.append("smith")
	
	if ( pc_data.dict["agility"] + pc_data.dict["endurance"] + pc_data.dict["bow"]
	+ pc_data.dict["throw"] + pc_data.dict["polearm"] + pc_data.dict["woodwise"] + pc_data.dict["riding"]
	) > 210:
		jobs_available.append("hunter")
	
	if ( pc_data.dict["intelligence"] + pc_data.dict["perception"] + pc_data.dict["heal"]
	+ pc_data.dict["alchemy"] + pc_data.dict["read_write"] + pc_data.dict["latin"]
	) > 180:
		jobs_available.append("physician")
	
	if ( pc_data.dict["perception"] + pc_data.dict["endurance"] + pc_data.dict["polearm"]
	+ pc_data.dict["religion"] + pc_data.dict["read_write"] + pc_data.dict["righteous"]
	+ pc_data.dict["latin"] ) > 210:
		jobs_available.append("church")
	
	if ( pc_data.dict["intelligence"] + pc_data.dict["perception"] + pc_data.dict["charisma"]
	+ pc_data.dict["alchemy"] + pc_data.dict["heal"] + pc_data.dict["read_write"]
	+ pc_data.dict["speak"] + pc_data.dict["religion"] + pc_data.dict["latin"]
	) > 270:
		jobs_available.append("student")
	
	if ( pc_data.dict["intelligence"] + pc_data.dict["charisma"] + pc_data.dict["perception"]
	+ pc_data.dict["trade"] + pc_data.dict["speak"] + pc_data.dict["read_write"]
	+ pc_data.dict["streetwise"] ) > 210:
		jobs_available.append("merchant")
