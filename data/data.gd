extends Node
# variables that are used game-wide are stored directly in Data
# variables specific to the party are stored in the Party script

# game settings such as audio volume
var settings: Dictionary = {"music_volume":0, "sfx_volume":0}
# the current time and date in the game
var time: Dictionary = {"hour":0, "day":0, "month":0, "year":0}
var minute: int:
	get:
		return minute
	set(value):
		minute = value
		time["hour"] = minute / 60
		#check and advance day
		if time["hour"] >= 24:
			minute = minute % 1440
			time["hour"] = time["hour"] % 24
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

func save_game():
	var save_file = FileAccess.open("user://one.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(settings)
	save_file.store_line(json_string)
	
	json_string = JSON.stringify(time)
	save_file.store_line(json_string)
	
	json_string = JSON.stringify($Party.dict)
	save_file.store_line(json_string)

	json_string = JSON.stringify($PC1.dict)
	save_file.store_line(json_string)
	
	json_string = JSON.stringify($PC2.dict)
	save_file.store_line(json_string)
	
	json_string = JSON.stringify($PC3.dict)
	save_file.store_line(json_string)
	
	json_string = JSON.stringify($PC4.dict)
	save_file.store_line(json_string)
	
	json_string = JSON.stringify($PC5.dict)
	save_file.store_line(json_string)
	
	json_string = JSON.stringify($World.dict)
	save_file.store_line(json_string)
	
	save_file.close()

func load_game(file):
	if not FileAccess.file_exists(file):
		return # Error! We don't have a save to load.
	
	var save_file = FileAccess.open(file, FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", 
			json_string, " at line ", json.get_error_line())
			continue
		settings = json.get_data()
		
		json_string = save_file.get_line()
		json = JSON.new()
		parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", 
			json_string, " at line ", json.get_error_line())
			continue
		time = json.get_data()
		minute = time["hour"] * 60
		
		json_string = save_file.get_line()
		json = JSON.new()
		parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", 
			json_string, " at line ", json.get_error_line())
			continue
		$Party.dict = json.get_data()
		
		json_string = save_file.get_line()
		json = JSON.new()
		parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", 
			json_string, " at line ", json.get_error_line())
			continue
		$PC1.dict = json.get_data()
		
		json_string = save_file.get_line()
		json = JSON.new()
		parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", 
			json_string, " at line ", json.get_error_line())
			continue
		$PC2.dict = json.get_data()
		
		json_string = save_file.get_line()
		json = JSON.new()
		parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", 
			json_string, " at line ", json.get_error_line())
			continue
		$PC3.dict = json.get_data()
		
		json_string = save_file.get_line()
		json = JSON.new()
		parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", 
			json_string, " at line ", json.get_error_line())
			continue
		$PC4.dict = json.get_data()
		
		json_string = save_file.get_line()
		json = JSON.new()
		parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", 
			json_string, " at line ", json.get_error_line())
			continue
		$PC5.dict = json.get_data()
		
		json_string = save_file.get_line()
		json = JSON.new()
		parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", 
			json_string, " at line ", json.get_error_line())
			continue
		$World.dict = json.get_data()
		
		save_file.close()
		return

func get_bell_time():
	if time["hour"] >= 5 and time["hour"] < 6:
		return "Matins"
	elif time["hour"] >= 6 and time["hour"] < 9:
		return "Prime"
	elif time["hour"] >= 9 and time["hour"] < 13:
		return "Terce"
	elif time["hour"] >= 13 and time["hour"] < 15:
		return "Sext"
	elif time["hour"] >= 15 and time["hour"] < 17:
		return "None"
	elif time["hour"] >= 17 and time["hour"] < 20:
		return "Vespers"
	else:
		return "Compline"

