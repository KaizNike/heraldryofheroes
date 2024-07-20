extends Control

var inventory: Dictionary = {}
var stats: Dictionary = {"money":500,"location":"LeipzigInn"}
var party_best
var time: Dictionary = {"hour":8, "day":1, "month":3, "year":1400}
var hour: int:
	get:
		return hour
	set(value):
		hour = hour + value
		time["hour"] = hour
		#check and advance day
		if hour >= 24:
			hour = 0
			time["day"] += 1
			#check and advance month
			if (time["month"] == 1 or time["month"] == 3 or time["month"] == 5 or time["month"] == 7
				or time["month"] == 8 or time["month"] == 10 or time["month"] == 12) and time["day"] > 31:
				time["day"] = 1
				time["month"] += 1
			elif time["month"] == 2 and time["day"] > 28:
				time["day"] = 1
				time["month"] += 1
			elif (time["month"] == 4 or time["month"] == 6 or time["month"] == 9
				or time["month"] == 11) and time["day"] > 30:
				time["day"] = 1
				time["month"] += 1
			#check and advance year
			if time["month"]/12 == 1:
				time["month"] = 1
				time["year"] += 1

func _ready():
	pass

func save_game():
	var save_file = FileAccess.open("user://pc1.save", FileAccess.WRITE)
	var a_dict = get_node("PC1").save_dict()
	var json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://pc2.save", FileAccess.WRITE)
	a_dict = get_node("PC2").save_dict()
	json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://pc3.save", FileAccess.WRITE)
	a_dict = get_node("PC3").save_dict()
	json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://pc4.save", FileAccess.WRITE)
	a_dict = get_node("PC4").save_dict()
	json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://pc5.save", FileAccess.WRITE)
	a_dict = get_node("PC5").save_dict()
	json_string = JSON.stringify(a_dict)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://inventory.save", FileAccess.WRITE)
	json_string = JSON.stringify(inventory)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://stats.save", FileAccess.WRITE)
	json_string = JSON.stringify(stats)
	save_file.store_line(json_string)
	save_file.close()
	
	save_file = FileAccess.open("user://time.save", FileAccess.WRITE)
	json_string = JSON.stringify(time)
	save_file.store_line(json_string)
	save_file.close()

func save_notes(text):
	var save_file = FileAccess.open("user://notes.save", FileAccess.WRITE)
	var a_dict = {"notes":text}
	var json_string = JSON.stringify(a_dict)
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


func get_party_best(stat):
	return max(
		int(Data.get_node("PC1").dict[stat]),
		int(Data.get_node("PC2").dict[stat]),
		int(Data.get_node("PC3").dict[stat]),
		int(Data.get_node("PC4").dict[stat])
		)
		
func get_bell_time():
	if hour >= 5 and hour < 6:
		return "Matins"
	elif hour >= 6 and hour < 9:
		return "Prime"
	elif hour >= 9 and hour < 13:
		return "Terce"
	elif hour >= 13 and hour < 15:
		return "Sext"
	elif hour >= 15 and hour < 17:
		return "None"
	elif hour >= 17 and hour < 20:
		return "Vespers"
	else:
		return "Compline"

func shuffle_up_party():
	if Main.pc1.visible:
		pass
	else:
		if Main.pc2.visible:
			$PC1.dict = $PC2.dict
			$PC2.clear_dict()
			Main.pc2.visible = false
		elif Main.pc3.visible:
			$PC1.dict = $PC3.dict
			$PC3.clear_dict()
			Main.pc3.visible = false
		elif Main.pc4.visible:
			$PC1.dict = $PC4.dict
			$PC4.clear_dict()
			Main.pc4.visible = false
		elif Main.pc5.visible:
			$PC1.dict = $PC5.dict
			$PC5.clear_dict()
			Main.pc5.visible = false
		Main.update_boxes()
	
	if Main.pc2.visible:
		pass
	else:
		if Main.pc3.visible:
			$PC2.dict = $PC3.dict
			$PC3.clear_dict()
			Main.pc3.visible = false
		elif Main.pc4.visible:
			$PC2.dict = $PC4.dict
			$PC4.clear_dict()
			Main.pc3.visible = false
		elif Main.pc5.visible:
			$PC2.dict = $PC5.dict
			$PC5.clear_dict()
			Main.pc4.visible = false
		Main.update_boxes()
	
	if Main.pc3.visible:
		pass
	else:
		if Main.pc4.visible:
			$PC3.dict = $PC4.dict
			$PC4.clear_dict()
			Main.pc4.visible = false
		elif Main.pc5.visible:
			$PC3.dict = $PC5.dict
			$PC5.clear_dict()
			Main.pc5.visible = false
		Main.update_boxes()
	
	if Main.pc4.visible:
		pass
	else:
		if Main.pc5.visible:
			$PC4.dict = $PC5.dict
			$PC5.clear_dict()
			Main.pc5.visible = false
		Main.update_boxes()
		
	
	
