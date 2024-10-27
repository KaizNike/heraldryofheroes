extends Node

var dict: Dictionary = {}
@onready var stats: Array[Statistic] = [
	preload("res://data/character_data/stats/endurance.tres"),
	preload("res://data/character_data/stats/strength.tres"),
	preload("res://data/character_data/stats/agility.tres"),
	preload("res://data/character_data/stats/intelligence.tres"),
	preload("res://data/character_data/stats/perception.tres"),
	preload("res://data/character_data/stats/charisma.tres")
]

enum Health {OKAY, UNCONSCIOUS, DEAD}

var endurance_max: int:
	get:
		return dict["endurance_max"]
	set(value):
		dict["endurance"] += value - dict["endurance_max"]
		dict["endurance_max"] = value
		if dict["endurance"] < 1:
			dict["endurance"] = 1
var endurance: int:
	get:
		return dict["endurance"]
	set(value):
		dict["endurance_change"] = value - dict["endurance"]
		dict["endurance"] = value
		if dict["endurance"] < 1:
			dict["health"] = Health.UNCONSCIOUS
		elif dict["endurance"] > dict["endurance_max"]:
			dict["endurance"] = dict["endurance_max"]

func update_dict():
	if dict["age"] < 30:
		dict["portrait"] = "res://images/portraits/m" + dict["portrait_set"] + "/20s.jpg"
	elif dict["age"] < 40:
		dict["portrait"] = "res://images/portraits/m" + dict["portrait_set"] + "/30s.jpg"
	elif dict["age"] < 50:
		dict["portrait"] = "res://images/portraits/m" + dict["portrait_set"] + "/40s.jpg"
	elif dict["age"] < 60:
		dict["portrait"] = "res://images/portraits/m" + dict["portrait_set"] + "/50s.jpg"
	elif dict["age"] < 70:
		dict["portrait"] = "res://images/portraits/m" + dict["portrait_set"] + "/60s.jpg"
	else:
		dict["portrait"] = "res://images/portraits/m" + dict["portrait_set"] + "/70s.jpg"

func clear_dict():
	for i in dict.keys():
		dict[i] = null
	dict["first_name"] = null
	dict["helmet_slot"] = "Empty"
	dict["vest_slot"] = "Empty"
	dict["leggings_slot"] = "Empty"
	dict["main_weapon_slot"] = "Empty"
	dict["side_arm_slot"] = "Empty"
	dict["shield_slot"] = "Empty"
	dict["ranged_weapon_slot"] = "Empty"
	dict["potion_one_slot"] = "Empty"
	dict["potion_two_slot"] = "Empty"
	
func create_pc():
	var birthday = str(1+randi()%28)+"/"+str(1+randi()%12)+"/"+str(Data.time["year"]-20-randi()%40)
	var byear = birthday.get_slice("/",2)
	var bmonth = birthday.get_slice("/",1)
	var bday = birthday.get_slice("/",0)
	var age = Data.time["year"] - int(byear)
	if Data.time["month"] < int(bmonth):
		age -= 1
	elif Data.time["month"] == int(bmonth) and Data.time["day"] < int(bday):
		age -= 1
		
	if bday == "1" or bday == "21" or bday == "31":
		bday = bday + "st"
	elif bday == "2" or bday == "22":
		bday = bday + "nd"
	elif bday == "3" or bday == "23":
		bday = bday + "rd"
	else:
		bday = bday + "th"
	match bmonth:
		"1":
			bmonth = "January"
		"2":
			bmonth = "February"
		"3":
			bmonth = "March"
		"4":
			bmonth = "April"
		"5":
			bmonth = "May"
		"6":
			bmonth = "June"
		"7":
			bmonth = "July"
		"8":
			bmonth = "August"
		"9":
			bmonth = "September"
		"10":
			bmonth = "October"
		"11":
			bmonth = "November"
		"12":
			bmonth = "December"
	
	var birthplace = "Leipzig" 
	
	var factor = 2
	var endurance = 10 - abs(age-35)/factor
	var strength = 10 - abs(age-30)/factor
	var agility = 10 - abs(age-25)/factor
	var intelligence = 10 - abs(age-45)/factor
	var perception = 10 - abs(age-50)/factor
	var charisma = 10 - abs(age-40)/factor
	
	var sex
	var she_he
	var her_his
	var her_him
	var first_name
	var last_name
	var portrait
	var portrait_set
	var names_women = ["Anna","Maria","Elisabeth","Margaretha","Katharina","Ursula","Agnes",
		"Barbara","Helena","Dorothea","Johanna","Sophia","Clara","Eva","Magdalena","Alice",
		"Christina","Eva","Gertrud","Kunigunde","Franziska","Adelheid","Margarete","Mathilde",
		"Berta","Beatrix","Hedwig","Barbara","Gisela","Brigida","Juliana","Thekla","Rosina",
		"Ottilie","Dorothea","Agnes","Renata","Elisabeth","Amalia","Hedwig","Ida","Hildegard",
		"Sabina","Salome","Klara","Melchiora","Cecilia","Alida","Lucia","Margret"]
	var names_men = ["Heinrich","Wilhelm","Johannes","Georg","Friedrich","Albrecht",
		"Hans","Martin","Ludwig","Jakob","Conrad","Philipp","Nikolaus","Andreas","Dietrich",
		"Rudolf","Otto","Eberhard","Michael","Siegfried","Anton","Ludwig","August","Bernhard",
		"Gotthard","Hermann","Stefan","Valentin","Bruno","Elias","Carl","Hugo","Kaspar",
		"Walter","Lorenz","Urban","Wilhelm","Hermann","Jacobus","Leonard","Ernst","Johannes",
		"Nikolaus","Simon","Matthias","Georgius","Gottfried","Franz","Engelbert","Max"]
	var names_family = ["Müller","Schmidt","Schneider","Fischer","Weber","Meyer","Hoffmann",
		"Braun","Wagner","Schmidt","Lange","Richter","Zimmermann","Koch","Klein","Schuster",
		"König","Engel","Weiss","Schmid","Roth","Wolf","Bauer","Herrmann","Lehmann","Günther",
		"Brandt","Schulz","Jung","Adler","Frank","Sommer","Bender","Nickel","Reuter","Kaiser",
		"Stein","Horn","Heinemann","Huber","Hesse","Bartel","Pohl","Dörner","Krämer","Marx",
		"Götz","Metzger","Voss","Dietrich"]

	if randi()%2 == 0:
		sex = "female"
		she_he = "she"
		her_his = "her"
		her_him = "her"
		first_name = names_women[randi() % names_women.size()]
		
		endurance += 1
		strength -= 2
		agility -= 1
		charisma += 2
		
		# select portrait set then remove that set from the dictionary, avoids identical pcs
		portrait_set = Data.get_node("World").dict["portraits_women"][0]
		if portrait_set != "999":
			Data.get_node("World").dict["portraits_women"].remove_at(0)
		
		if age < 30:
			portrait = "res://images/portraits/f" + portrait_set + "/20s.jpg"
		elif age < 40:
			portrait = "res://images/portraits/f" + portrait_set + "/30s.jpg"
		elif age < 50:
			portrait = "res://images/portraits/f" + portrait_set + "/40s.jpg"
		elif age < 60:
			portrait = "res://images/portraits/f" + portrait_set + "/50s.jpg"
		elif age < 70:
			portrait = "res://images/portraits/f" + portrait_set + "/60s.jpg"
		else:
			portrait = "res://images/portraits/f" + portrait_set + "/70s.jpg"
	else:
		sex = "male"
		she_he = "he"
		her_his = "his"
		her_him = "him"
		first_name = names_men[randi() % names_men.size()]
		
		endurance -= 1
		strength += 2
		agility += 1
		charisma -= 2
		
		portrait_set = Data.get_node("World").dict["portraits_men"][0]
		if portrait_set != "999":
			Data.get_node("World").dict["portraits_men"].remove_at(0)
		
		if age < 30:
			portrait = "res://images/portraits/m" + portrait_set + "/20s.jpg"
		elif age < 40:
			portrait = "res://images/portraits/m" + portrait_set  + "/30s.jpg"
		elif age < 50:
			portrait = "res://images/portraits/m" + portrait_set  + "/40s.jpg"
		elif age < 60:
			portrait = "res://images/portraits/m" + portrait_set  + "/50s.jpg"
		elif age < 70:
			portrait = "res://images/portraits/m" + portrait_set  + "/60s.jpg"
		else:
			portrait = "res://images/portraits/m" + portrait_set  + "/70s.jpg"
	
	last_name = names_family[randi() % names_family.size()]
	
	var rando
	var ability_points = 150
	while ability_points > 0:
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
	
	var major = 1
	var minor = 3
	
	var blade = endurance/major + agility/minor + randi() % factor
	var impact = strength/major + endurance/minor + randi() % factor
	var flail = strength/major + perception/minor + randi() % factor
	var polearm = endurance/major + agility/minor + randi() % factor
	var throw = agility/major + strength/minor + randi() % factor
	var bow = agility/major + strength/minor + randi() % factor
	var gun = agility/major + perception/minor + randi() % factor
	var shield = endurance/major + agility/minor + randi() % factor

	var alchemy = intelligence/major + perception/minor + randi() % factor
	var heal = perception/major + intelligence/minor + randi() % factor
	var religion = perception/major + charisma/minor + randi() % factor
	var latin = intelligence/major + charisma/minor + randi() % factor
	var read_write = intelligence/major + perception/minor + randi() % factor
	var righteous = endurance/major + charisma/minor + randi() % factor
	
	var speak = charisma/major + perception/minor + randi() % factor
	var artifice = agility/major + perception/minor + randi() % factor
	var streetwise = perception/major + charisma/minor + randi() % factor
	var riding = agility/major + endurance/minor + randi() % factor
	var woodwise = perception/major + intelligence/minor + randi() % factor
	var trade = charisma/major + perception/minor + randi() % factor

	var blessing = (religion + righteous)/2

	dict["portrait"] = portrait
	dict["portrait_set"] = portrait_set
	dict["first_name"] = first_name
	dict["last_name"] = last_name
	dict["sex"] = sex
	dict["she_he"] = she_he
	dict["her_his"] = her_his
	dict["her_him"] = her_him
	dict["age"] = age
	dict["birthday"] = birthday
	dict["birthday_words"] = bmonth + " " + bday + " " + byear
	dict["birthplace"] = birthplace
	dict["endurance"] = int(endurance)
	dict["endurance_max"] = int(endurance)
	dict["endurance_change"] = 0
	dict["strength"] = int(strength)
	dict["strength_max"] = int(strength)
	dict["strength_change"] = 0
	dict["blessing"] = int(blessing)
	dict["blessing_max"] = int(blessing)
	dict["blessing_change"] = 0
	dict["agility"] = int(agility)
	dict["agility_max"] = int(agility)
	dict["agility_change"] = 0
	dict["intelligence"] = int(intelligence)
	dict["intelligence_max"] = int(intelligence)
	dict["intelligence_change"] = 0
	dict["perception"] = int(perception)
	dict["perception_max"] = int(perception)
	dict["perception_change"] = 0
	dict["charisma"] = int(charisma)
	dict["charisma_max"] = int(charisma)
	dict["charisma_change"] = 0

	dict["blade"] = int(blade)
	dict["blade_change"] = 0
	dict["impact"] = int(impact)
	dict["impact_change"] = 0
	dict["flail"] = int(flail)
	dict["flail_change"] = 0
	dict["polearm"] = int(polearm)
	dict["polearm_change"] = 0
	dict["throw"] = int(throw)
	dict["throw_change"] = 0
	dict["bow"] = int(bow)
	dict["bow_change"] = 0
	dict["gun"] = int(gun)
	dict["gun_change"] = 0
	dict["shield"] = int(shield)
	dict["shield_change"] = 0

	dict["alchemy"] = int(alchemy)
	dict["alchemy_change"] = 0
	dict["heal"] = int(heal)
	dict["heal_change"] = 0
	dict["religion"] = int(religion)
	dict["religion_change"] = 0
	dict["righteous"] = int(righteous)
	dict["righteous_change"] = 0
	dict["latin"] = int(latin)
	dict["latin_change"] = 0
	dict["read_write"] = int(read_write)
	dict["read_write_change"] = 0

	dict["speak"] = int(speak)
	dict["speak_change"] = 0
	dict["artifice"] = int(artifice)
	dict["artifice_change"] = 0
	dict["streetwise"] = int(streetwise)
	dict["streetwise_change"] = 0
	dict["riding"] = int(riding)
	dict["riding_change"] = 0
	dict["woodwise"] = int(woodwise)
	dict["woodwise_change"] = 0
	dict["trade"] = int(trade)
	dict["trade_change"] = 0
	
	dict["helmet_slot"] = "\u0080Chain Helmet@25"
	dict["vest_slot"] = "\u0081Plate Vest@25"
	dict["leggings_slot"] = "\u0082Leather Leggings@25"
	dict["main_weapon_slot"] = "\u0083Longsword@25"
	dict["side_arm_slot"] = "\u0083Military Hammer@25"
	dict["shield_slot"] = "\u0084Small Shield@25"
	dict["ranged_weapon_slot"] = "\u0086Short Bow@25"
	dict["potion_one_slot"] = "\u0087Healing Potion@25"
	dict["potion_two_slot"] = "\u0087Splinter Blast@25"
