extends Node

@onready var pc1 = Data.get_node("PC1")
@onready var pc2 = Data.get_node("PC2")
@onready var pc3 = Data.get_node("PC3")
@onready var pc4 = Data.get_node("PC4")
@onready var pc5 = Data.get_node("PC5")

var dict: Dictionary = {
	# these variables are used to remember which pc is active between
	# scenarios because scenarios don't share info with each other
	"pc_focus":"",
	"prev_outcome":"",
	"heraldry":"",
	# the party's current location
	"location":"",
	"notes":"",
	"inventory":{},
	"money":0,
	"party_best":0
	}

# party_best gets the highest stat amongst members of the party
func get_party_best(stat):
	var pc1_stat = 0
	if pc1.dict[stat] != null:
		pc1_stat = int(pc1.dict[stat])
	var pc2_stat = 0
	if pc2.dict[stat] != null:
		pc2_stat = int(pc2.dict[stat])
	var pc3_stat = 0
	if pc3.dict[stat] != null:
		pc3_stat = int(pc3.dict[stat])
	var pc4_stat = 0
	if pc4.dict[stat] != null:
		pc4_stat = int(pc4.dict[stat])
	var pc5_stat = 0
	if pc5.dict[stat] != null:
		pc5_stat = int(pc5.dict[stat])
	
	return max(pc1_stat, pc2_stat, pc3_stat, pc4_stat, pc5_stat)

# used to move up PC Boxes on left of screen so that no empty spaces between
func shuffle_up_party():
	if Main.pc1.visible:
		pass
	else:
		if Main.pc2.visible:
			pc1.dict = pc2.dict
			pc2.clear_dict()
			Main.pc2.visible = false
		elif Main.pc3.visible:
			pc1.dict = pc3.dict
			pc3.clear_dict()
			Main.pc3.visible = false
		elif Main.pc4.visible:
			pc1.dict = pc4.dict
			pc4.clear_dict()
			Main.pc4.visible = false
		elif Main.pc5.visible:
			pc1.dict = pc5.dict
			pc5.clear_dict()
			Main.pc5.visible = false
		Main.update_boxes()
	
	if Main.pc2.visible:
		pass
	else:
		if Main.pc3.visible:
			pc2.dict = pc3.dict
			pc3.clear_dict()
			Main.pc3.visible = false
		elif Main.pc4.visible:
			pc2.dict = pc4.dict
			pc4.clear_dict()
			Main.pc3.visible = false
		elif Main.pc5.visible:
			pc2.dict = pc5.dict
			pc5.clear_dict()
			Main.pc4.visible = false
		Main.update_boxes()
	
	if Main.pc3.visible:
		pass
	else:
		if Main.pc4.visible:
			pc3.dict = pc4.dict
			pc4.clear_dict()
			Main.pc4.visible = false
		elif Main.pc5.visible:
			pc3.dict = pc5.dict
			pc5.clear_dict()
			Main.pc5.visible = false
		Main.update_boxes()
	
	if Main.pc4.visible:
		pass
	else:
		if Main.pc5.visible:
			pc4.dict = pc5.dict
			pc5.clear_dict()
			Main.pc5.visible = false
		Main.update_boxes()
