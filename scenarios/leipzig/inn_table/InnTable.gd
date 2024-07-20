extends TextureRect

@onready var is_text_faded_in = true
var next_scene = null
var winter = false
var night = false

var FirstNamesMen = ["Gunther","Hans","Peter","Jonas","Klaus","Georg","Bruno","Helmut","Konrad","Herman","Leopold"]
var FirstNamesWomen = ["Theresa","Borghild","Rita","Gretchen","Fleur","Dagna","Frederika","Frieda","Giselle"]
var LastNames = ["van Meer","Spiegler","Zimmerhof","Drechen","Pretzel","Heller","Lamar","Luther"]

func _ready():
	Data.shuffle_up_party()
	Data.hour = 1
	if Data.time["month"] > 2 and Data.time["month"] < 12:
		winter = false
		if Data.hour > 6 and Data.hour < 18:
			night = false
		else:
			night = true
	else:
		winter = true
		if Data.hour > 8 and Data.hour < 16:
			night = false
		else:
			night = true
	$TextBox/Time.text = "It is " + Data.get_bell_time()
	
	Data.stats["location"] = "leipzig/inn_table/InnTable"
	Data.save_game()
	
	$Audio.playing = true
	$Audio/Player.play("fade_in")
	fade_in_scenery()
	await $FadePanel/Player.animation_finished
	is_text_faded_in = false
	
	if Main.pc1.visible:
		$TextBox/Options/DismissPC1.text = "...dismiss " + Data.get_node("PC1").dict["first_name"] + " from the party."
	else:
		$TextBox/Options/DismissPC1.visible = false
	
	if Main.pc2.visible:
		get_node("TextBox/Options/DismissPC2").text = "...dismiss " + Data.get_node("PC2").dict["first_name"] + " from the party."
	else:
		$TextBox/Options/DismissPC2.visible = false
	
	if Main.pc3.visible:
		get_node("TextBox/Options/DismissPC3").text = "...dismiss " + Data.get_node("PC3").dict["first_name"] + " from the party."
	else:
		$TextBox/Options/DismissPC3.visible = false
	
	if Main.pc4.visible:
		get_node("TextBox/Options/DismissPC4").text = "...dismiss " + Data.get_node("PC4").dict["first_name"] + " from the party."
	else:
		$TextBox/Options/DismissPC4.visible = false
	
	if Main.pc5.visible:
		get_node("TextBox/Options/DismissPC5").text = "...dismiss " + Data.get_node("PC5").dict["first_name"] + " from the party."
	else:
		$TextBox/Options/DismissPC5.visible = false
	
# Buttons
func _on_recruit_pc_pressed():
	#create new player character and write their stats to data nodes and place in next available pc box
	if Main.pc1.visible == false:
		new_player("PC1")
		Main.pc1.update_box("PC1")
	elif Main.pc2.visible == false:
		new_player("PC2")
		Main.pc2.update_box("PC2")
	elif Main.pc3.visible == false:
		new_player("PC3")
		Main.pc3.update_box("PC3")
	elif Main.pc4.visible == false:
		new_player("PC4")
		Main.pc4.update_box("PC4")
	elif Main.pc5.visible == false:
		new_player("PC5")
		Main.pc5.update_box("PC5")
	
	Main.goto_scene("res://scenarios/leipzig/inn_table/InnTable.tscn")
	
func _on_dismiss_pc_1_pressed():
	Main.pc1.visible = false
	Data.get_node("PC1").clear_dict()
	Main.goto_scene("res://scenarios/leipzig/inn_table/InnTable.tscn")
	
func _on_dismiss_pc_2_pressed():
	Main.pc2.visible = false
	Data.get_node("PC2").clear_dict()
	Main.goto_scene("res://scenarios/leipzig/inn_table/InnTable.tscn")

func _on_dismiss_pc_3_pressed():
	Main.pc3.visible = false
	Data.get_node("PC3").clear_dict()
	Main.goto_scene("res://scenarios/leipzig/inn_table/InnTable.tscn")

func _on_dismiss_pc_4_pressed():
	Main.pc4.visible = false
	Data.get_node("PC4").clear_dict()
	Main.goto_scene("res://scenarios/leipzig/inn_table/InnTable.tscn")

func _on_dismiss_pc_5_pressed():
	Main.pc5.visible = false
	Data.get_node("PC5").clear_dict()
	Main.goto_scene("res://scenarios/leipzig/inn_table/InnTable.tscn")

func _on_inn_pressed():
	$TextBox/Outcome.text = "You leave the table and return to the inn."
	next_scene = "res://scenarios/leipzig/inn/Inn.tscn"
	scene_outcome()
	
func scene_outcome():
	$TextBox/Outcome.visible = true
	$Audio/Player.play("fade_out")
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
			texture = load("res://scenarios/leipzig/inn_table/InnTable-WN.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/inn_table/InnTable-WD.jpg")
			$FadePanel/Player.play("fade_in_light")
	else:
		if night:
			texture = load("res://scenarios/leipzig/inn_table/InnTable-SN.jpg")
			$FadePanel/Player.play("fade_in_dark")
		else:
			texture = load("res://scenarios/leipzig/inn_table/InnTable-SD.jpg")
			$FadePanel/Player.play("fade_in_light")
	
func fade_in_text():
	$TextBox.visible = true
	$TextBox/Options/Inn.grab_focus()
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
		
func new_player(player):
	var pc_data = Data.get_node(player)
	
	var birthday = str(1+randi()%28)+"/"+str(1+randi()%12)+"/"+str(Data.time["year"]-20-randi()%40)
	var age = Data.time["year"] - int(birthday.get_slice("/",2))
	var birthplace = "Leipzig" 

	var rando
	
	var factor = 2
	var endurance = 10 - abs(age-35)/factor
	var strength = 10 - abs(age-30)/factor
	var agility = 10 - abs(age-25)/factor
	var intelligence = 10 - abs(age-45)/factor
	var perception = 10 - abs(age-50)/factor
	var charisma = 10 - abs(age-40)/factor
	
	var sex
	var first_name
	var last_name
	var portrait
	randomize()
	rando = randi()%2
	if rando == 0:
		sex = "Male"
		endurance -= 1
		strength += 2
		agility += 1
		charisma -= 2
		first_name = FirstNamesMen[randi() % FirstNamesMen.size()]
		if age < 30:
			portrait = "res://images/portraits/Man2.jpg"
		elif age < 40:
			portrait = "res://images/portraits/Man1.jpg"
		else:
			portrait = "res://images/portraits/Man3.jpg"
	else:
		sex = "Female"
		endurance += 1
		strength -= 2
		agility -= 1
		charisma += 2
		first_name = FirstNamesWomen[randi() % FirstNamesWomen.size()]
		if age < 30:
			portrait = "res://images/portraits/Woman1.jpg"
		elif age < 40:
			portrait = "res://images/portraits/Woman3.jpg"
		else:
			portrait = "res://images/portraits/Woman2.jpg"
	
	last_name = LastNames[randi() % LastNames.size()]
	
	var ability_points = 200
	while ability_points > 0:
		randomize()
		factor = 10
		
		rando = randi() % factor
		endurance += rando
		ability_points -= rando
		
		rando = randi() % factor
		strength += rando
		ability_points -= rando
		
		rando = randi() % factor
		agility += rando
		ability_points -= rando
		
		rando = randi() % factor
		intelligence += rando
		ability_points -= rando
		
		rando = randi() % factor
		perception += rando
		ability_points -= rando
		
		rando = randi() % factor
		charisma += rando
		ability_points -= rando
	
	var skill_points = 100+age
	var major = 1
	var minor = 3
	
	var blade = 1 + endurance/major + agility/minor
	var impact = 1 + strength/major + endurance/minor
	var flail = 1 + strength/major + perception/minor
	var polearm = 1 + endurance/major + agility/minor
	var throw = 1 + agility/major + strength/minor
	var bow = 1 + agility/major + strength/minor
	var gun = 1 + agility/major + perception/minor
	var shield = 1 + endurance/major + agility/minor

	var alchemy = 1 + intelligence/major + perception/minor
	var heal = 1 + perception/major + intelligence/minor
	var religion = 1 + perception/major + charisma/minor
	var latin = 1 + intelligence/major + charisma/minor
	var read_write = 1 + intelligence/major + perception/minor

	var righteous = 1 + endurance/major + charisma/minor
	var speaking = 1 + charisma/major + perception/minor
	var artifice = 1 + agility/major + perception/minor
	var streetwise = 1 + perception/major + charisma/minor
	var riding = 1 + agility/major + endurance/minor
	var woodwise = 1 + perception/major + intelligence/minor
	var trade = 1 + charisma/major + perception/minor
	
	while skill_points > 0:
		randomize()
		factor = 4
		
		rando = randi() % 2
		blade += rando * endurance/factor
		skill_points -= rando * endurance/factor
		
		rando = randi() % 2
		impact += rando * strength/factor
		skill_points -= rando * strength/factor
		
		rando = randi() % 2
		flail += rando * strength/factor
		skill_points -= rando * strength/factor
		
		rando = randi() % 2
		polearm += rando * endurance/factor
		skill_points -= rando * endurance/factor
		
		rando = randi() % 2
		throw += rando * agility/factor
		skill_points -= rando * agility/factor
		
		rando = randi() % 2
		bow += rando * agility/factor
		skill_points -= rando * agility/factor
		
		rando = randi() % 2
		gun += rando * agility/factor
		skill_points -= rando * agility/factor
		
		rando = randi() % 2
		shield += rando * endurance/factor
		skill_points -= rando * endurance/factor
		
		rando = randi() % 2
		alchemy += rando * intelligence/factor
		skill_points -= rando * intelligence/factor
		
		rando = randi() % 2
		heal += rando * perception/factor
		skill_points -= rando * perception/factor
		
		rando = randi() % 2
		religion += rando * perception/factor
		skill_points -= rando * perception/factor
		
		rando = randi() % 2
		latin += rando * intelligence/factor
		skill_points -= rando * intelligence/factor
		
		rando = randi() % 2
		read_write += rando * intelligence/factor
		skill_points -= rando * intelligence/factor
		
		rando = randi() % 2
		righteous += rando * endurance/factor
		skill_points -= rando * endurance/factor
		
		rando = randi() % 2
		speaking += rando * charisma/factor
		skill_points -= rando * charisma/factor
		
		rando = (randi() % 2) * perception/factor
		speaking += rando
		skill_points -= rando
		
		rando = randi() % 2
		artifice += rando * agility/factor
		skill_points -= rando * agility/factor
		
		rando = randi() % 2
		streetwise += rando * perception/factor
		skill_points -= rando * perception/factor
		
		rando = randi() % 2
		riding += rando * agility/factor
		skill_points -= rando * agility/factor
		
		rando = randi() % 2
		woodwise += rando * perception/factor
		skill_points -= rando * perception/factor

	var blessing = (religion + righteous)/2

	pc_data.dict["portrait"] = portrait
	pc_data.dict["first_name"] = first_name
	pc_data.dict["last_name"] = last_name
	pc_data.dict["sex"] = sex
	pc_data.dict["age"] = age
	pc_data.dict["birthday"] = birthday
	pc_data.dict["birthplace"] = birthplace
	pc_data.dict["endurance"] = int(endurance)
	pc_data.dict["endurance_max"] = int(endurance)
	pc_data.dict["strength"] = int(strength)
	pc_data.dict["strength_max"] = int(strength)
	pc_data.dict["blessing"] = int(blessing)
	pc_data.dict["blessing_max"] = int(blessing)
	pc_data.dict["agility"] = int(agility)
	pc_data.dict["agility_max"] = int(agility)
	pc_data.dict["intelligence"] = int(intelligence)
	pc_data.dict["intelligence_max"] = int(intelligence)
	pc_data.dict["perception"] = int(perception)
	pc_data.dict["perception_max"] = int(perception)
	pc_data.dict["charisma"] = int(charisma)
	pc_data.dict["charisma_max"] = int(charisma)

	pc_data.dict["blade"] = int(blade)
	pc_data.dict["impact"] = int(impact)
	pc_data.dict["flail"] = int(flail)
	pc_data.dict["polearm"] = int(polearm)
	pc_data.dict["throw"] = int(throw)
	pc_data.dict["bow"] = int(bow)
	pc_data.dict["gun"] = int(gun)
	pc_data.dict["shield"] = int(shield)

	pc_data.dict["alchemy"] = int(alchemy)
	pc_data.dict["heal"] = int(heal)
	pc_data.dict["religion"] = int(religion)
	pc_data.dict["righteous"] = int(righteous)
	pc_data.dict["latin"] = int(latin)
	pc_data.dict["read_write"] = int(read_write)

	pc_data.dict["speaking"] = int(speaking)
	pc_data.dict["artifice"] = int(artifice)
	pc_data.dict["streetwise"] = int(streetwise)
	pc_data.dict["riding"] = int(riding)
	pc_data.dict["woodwise"] = int(woodwise)
	pc_data.dict["trade"] = int(trade)
	
	Data.stats["money"] += 100
	pc_data.dict["helmet_slot"] = "\u0080Chain Helmet"
	pc_data.dict["vest_slot"] = "\u0081Plate Vest"
	pc_data.dict["leggings_slot"] = "\u0082Leather Leggings"
	pc_data.dict["main_weapon_slot"] = "\u0083Longsword"
	pc_data.dict["side_arm_slot"] = "\u0083Military Hammer"
	pc_data.dict["shield_slot"] = "\u0084Small Shield"
	pc_data.dict["ranged_weapon_slot"] = "\u0085Short Bow"
	pc_data.dict["potion_one_slot"] = "\u0086Healing Potion"
	pc_data.dict["potion_two_slot"] = "\u0086Splinter Blast"

