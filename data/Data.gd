extends Control

var FirstNamesMen = ["Gunther","Hans","Peter","Jonas","Klaus","Georg","Bruno","Helmut","Konrad","Herman","Leopold"]
var FirstNamesWomen = ["Theresa","Borghild","Rita","Gretchen","Fleur","Dagna","Frederika","Frieda","Giselle"]
var LastNames = ["van Meer","Spiegler","Zimmerhof","Drechen","Pretzel","Heller","Lamar","Luther"]

var inventory: Dictionary = {}
var stats: Dictionary = {"money":500,"location":"LeipzigInn"}
var party_best
var time_dict: Dictionary = {"hour":1, "day":1, "month":1, "year":1400}
var time: int:
	get:
		return time
	set(value):
		time = time + value
		time_dict["hour"] = time
		if time >= 24:
			time = 0
			time_dict["day"] += 1
			if time_dict["day"]/30 == 1:
				time_dict["day"] = 1
				time_dict["month"] += 1
				if time_dict["month"]/12 == 1:
					time_dict["month"] = 1
					time_dict["year"] += 1

func _ready():
	pass

func save_game():
	var save_file = FileAccess.open("user://pc1_save.save", FileAccess.WRITE)
	var a_dict = get_node("PC1").save_dict()
	var json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://pc2_save.save", FileAccess.WRITE)
	a_dict = get_node("PC2").save_dict()
	json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://pc3_save.save", FileAccess.WRITE)
	a_dict = get_node("PC3").save_dict()
	json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://pc4_save.save", FileAccess.WRITE)
	a_dict = get_node("PC4").save_dict()
	json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://pc5_save.save", FileAccess.WRITE)
	a_dict = get_node("PC5").save_dict()
	json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://inventory_save.save", FileAccess.WRITE)
	json_string = JSON.stringify(inventory)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://stats_save.save", FileAccess.WRITE)
	json_string = JSON.stringify(stats)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://time_save.save", FileAccess.WRITE)
	json_string = JSON.stringify(time_dict)
	save_file.store_line(json_string)
	save_file.close()

func load_game(file):
	if not FileAccess.file_exists(file):
		return # Error! We don't have a save to load.
	
	var save_file = FileAccess.open(file, FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var dict = json.get_data()
		return dict

func new_player(player):
	var pc_data = get_node(player)
	pc_data.new_dict()
	
	var birthday = str(1+randi()%28)+"/"+str(1+randi()%12)+"/"+str(time_dict["year"]-20-randi()%40)
	var age = time_dict["year"] - int(birthday.get_slice("/",2))
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
	
	stats["money"] += 100
	pc_data.dict["helmet_slot"] = "\u0080Chain Helmet"
	pc_data.dict["vest_slot"] = "\u0081Plate Vest"
	pc_data.dict["leggings_slot"] = "\u0082Leather Leggings"
	pc_data.dict["main_weapon_slot"] = "\u0083Longsword"
	pc_data.dict["side_arm_slot"] = "\u0083Military Hammer"
	pc_data.dict["shield_slot"] = "\u0084Small Shield"
	pc_data.dict["ranged_weapon_slot"] = "\u0085Short Bow"
	pc_data.dict["potion_one_slot"] = "\u0086Healing Potion"
	pc_data.dict["potion_two_slot"] = "\u0086Splinter Blast"

func get_party_best(stat):
	return max(
		int(Data.get_node("PC1").dict[stat]),
		int(Data.get_node("PC2").dict[stat]),
		int(Data.get_node("PC3").dict[stat]),
		int(Data.get_node("PC4").dict[stat])
		)
		
func get_bell_time():
	if time >= 5 and time < 6:
		return "Matins"
	elif time >= 6 and time < 9:
		return "Prime"
	elif time >= 9 and time < 13:
		return "Terce"
	elif time >= 13 and time < 15:
		return "Sext"
	elif time >= 15 and time < 17:
		return "None"
	elif time >= 17 and time < 20:
		return "Vespers"
	else:
		return "Compline"
