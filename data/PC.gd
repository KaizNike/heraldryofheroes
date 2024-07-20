extends Node

var dict

func _ready():
	pass

func clear_dict():
	dict = {
		"portrait" : null,
		"first_name" : null,
		"last_name" : null,
		"sex" : null,
		"birthday" : null,
		"age" : null,
		"birthplace" : null,
		
		"endurance_max" : null,
		"endurance" : null,
		"strength_max" : null,
		"strength" : null,
		"blessing_max" : null,
		"blessing" : null,
		"agility_max" : null,
		"agility" : null,
		"intelligence_max" : null,
		"intelligence" : null,
		"perception_max" : null,
		"perception" : null,
		"charisma_max" : null,
		"charisma" : null,
		
		"blade" : null,
		"blade_change" : null,
		"impact" : null,
		"impact_change" : null,
		"flail" : null,
		"flail_change" : null,
		"polearm" : null,
		"polearm_change" : null,
		"shield" : null,
		"shield_change" : null,
		"throw" : null,
		"throw_change" : null,
		"bow" : null,
		"bow_change" : null,
		"gun" : null,
		"gun_change" : null,
		"alchemy" : null,
		"alchemy_change" : null,
		"heal" : null,
		"heal_change" : null,
		"religion" : null,
		"religion_change" : null,
		"righteous" : null,
		"virtue_change" : null,
		"latin" : null,
		"latin_change" : null,
		"read_write" : null,
		"read_write_change" : null,
		"speaking" : null,
		"speaking_change" : null,
		"trade" : null,
		"trade_change" : null,
		"artifice" : null,
		"artifice_change" : null,
		"streetwise" : null,
		"streetwise_change" : null,
		"riding" : null,
		"riding_change" : null,
		"woodwise" : null,
		"woodwise_change" : null,
		
		"helmet_slot" : "Empty",
		"vest_slot" : "Empty",
		"leggings_slot" : "Empty",
		"main_weapon_slot" : "Empty",
		"side_arm_slot" : "Empty",
		"shield_slot" : "Empty",
		"ranged_weapon_slot" : "Empty",
		"potion_one_slot" : "Empty",
		"potion_two_slot" : "Empty"
	}

func save_dict():
	return dict
