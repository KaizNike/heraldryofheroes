extends TextureRect

#shortcuts for accessing nodes
@onready var inventory_data = Data.get_node("Party").dict["inventory"]
@onready var party_inventory = get_node("HBox/InventoryFrame/Inventory/PartyInventory")
@onready var party_stats = get_node("HBox/PartyStatsFrame/PartyStats")
@onready var helmet_slot = get_node("HBox/CharacterFrame/Character/HelmetSlot")
@onready var vest_slot = get_node("HBox/CharacterFrame/Character/VestSlot")
@onready var leggings_slot = get_node("HBox/CharacterFrame/Character/LeggingsSlot")
@onready var main_weapon_slot = get_node("HBox/CharacterFrame/Character/MainWeaponSlot")
@onready var side_arm_slot = get_node("HBox/CharacterFrame/Character/SideArmSlot")
@onready var shield_slot = get_node("HBox/CharacterFrame/Character/ShieldSlot")
@onready var ranged_weapon_slot = get_node("HBox/CharacterFrame/Character/RangedWeaponSlot")
@onready var potion_one_slot = get_node("HBox/CharacterFrame/Character/PotionOneSlot")
@onready var potion_two_slot = get_node("HBox/CharacterFrame/Character/PotionTwoSlot")

var item_selected = null
var item_selected_index = null
var item_equipped = null
# the player character whose stats are displayed
var pc

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBox/InventoryFrame/Inventory/Money.text = str(Data.get_node("Party").dict["money"]) + "$"
	
	for i in inventory_data:
		party_inventory.add_item(inventory_data[i], null, true)
	
	if Main.get_node("HBox/Party/PC1Frame/PC1").disabled == true:
		pc = Data.get_node("PC1")
	elif Main.get_node("HBox/Party/PC2Frame/PC2").disabled == true:
		pc = Data.get_node("PC2")
	elif Main.get_node("HBox/Party/PC3Frame/PC3").disabled == true:
		pc = Data.get_node("PC3")
	elif Main.get_node("HBox/Party/PC4Frame/PC4").disabled == true:
		pc = Data.get_node("PC4")
	elif Main.get_node("HBox/Party/PC5Frame/PC5").disabled == true:
		pc = Data.get_node("PC5")
	
	helmet_slot.text = pc.dict["helmet_slot"]
	set_item_tooltip(helmet_slot)
	vest_slot.text = pc.dict["vest_slot"]
	set_item_tooltip(vest_slot)
	leggings_slot.text = pc.dict["leggings_slot"]
	set_item_tooltip(leggings_slot)
	main_weapon_slot.text = pc.dict["main_weapon_slot"]
	set_item_tooltip(main_weapon_slot)
	side_arm_slot.text = pc.dict["side_arm_slot"]
	set_item_tooltip(side_arm_slot)
	shield_slot.text = pc.dict["shield_slot"]
	set_item_tooltip(shield_slot)
	ranged_weapon_slot.text = pc.dict["ranged_weapon_slot"]
	set_item_tooltip(ranged_weapon_slot)
	potion_one_slot.text = pc.dict["potion_one_slot"]
	set_item_tooltip(potion_one_slot)
	potion_two_slot.text = pc.dict["potion_two_slot"]
	set_item_tooltip(potion_two_slot)
	
	$HBox/CharacterFrame/Character/Name.text = pc.dict["first_name"] + " " + pc.dict["last_name"]
	$HBox/CharacterFrame/Character/Birthday.text = ( "Born " + pc.dict["birthday_words"]
		+ " (" + str(pc.dict["age"]) + ") " )
	$HBox/CharacterFrame/Character/Birthplace.text = "...in " + pc.dict["birthplace"]
	
	$HBox/SkillsFrame/Skills/Endurance/Value.text = str(pc.dict["endurance"]) + "/" + str(pc.dict["endurance_max"])
	$HBox/SkillsFrame/Skills/Endurance/Change.text = " (" + str(pc.dict["endurance_change"]) + ")"
	if pc.dict["endurance_change"] > 0:
		$HBox/SkillsFrame/Skills/Endurance/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["endurance_change"] < 0:
		$HBox/SkillsFrame/Skills/Endurance/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Endurance/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Strength/Value.text = str(pc.dict["strength"]) + "/" + str(pc.dict["strength_max"])
	$HBox/SkillsFrame/Skills/Strength/Change.text = " (" + str(pc.dict["strength_change"]) + ")"
	if pc.dict["strength_change"] > 0:
		$HBox/SkillsFrame/Skills/Strength/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["strength_change"] < 0:
		$HBox/SkillsFrame/Skills/Strength/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Strength/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Agility/Value.text = str(pc.dict["agility"]) + "/" + str(pc.dict["agility_max"])
	$HBox/SkillsFrame/Skills/Agility/Change.text = " (" + str(pc.dict["agility_change"]) + ")"
	if pc.dict["agility_change"] > 0:
		$HBox/SkillsFrame/Skills/Agility/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["agility_change"] < 0:
		$HBox/SkillsFrame/Skills/Agility/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Agility/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Intelligence/Value.text = str(pc.dict["intelligence"]) + "/" + str(pc.dict["intelligence_max"])
	$HBox/SkillsFrame/Skills/Intelligence/Change.text = " (" + str(pc.dict["intelligence_change"]) + ")"
	if pc.dict["intelligence_change"] > 0:
		$HBox/SkillsFrame/Skills/Intelligence/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["intelligence_change"] < 0:
		$HBox/SkillsFrame/Skills/Intelligence/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Intelligence/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Perception/Value.text = str(pc.dict["perception"]) + "/" + str(pc.dict["perception_max"])
	$HBox/SkillsFrame/Skills/Perception/Change.text = " (" + str(pc.dict["perception_change"]) + ")"
	if pc.dict["perception_change"] > 0:
		$HBox/SkillsFrame/Skills/Perception/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["perception_change"] < 0:
		$HBox/SkillsFrame/Skills/Perception/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Perception/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Charisma/Value.text = str(pc.dict["charisma"]) + "/" + str(pc.dict["charisma_max"])
	$HBox/SkillsFrame/Skills/Charisma/Change.text = " (" + str(pc.dict["charisma_change"]) + ")"
	if pc.dict["charisma_change"] > 0:
		$HBox/SkillsFrame/Skills/Charisma/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["charisma_change"] < 0:
		$HBox/SkillsFrame/Skills/Charisma/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Charisma/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Blade/Value.text = str(pc.dict["blade"])
	$HBox/SkillsFrame/Skills/Blade/Change.text = " (" + str(pc.dict["blade_change"]) + ")"
	if pc.dict["blade_change"] > 0:
		$HBox/SkillsFrame/Skills/Blade/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["blade_change"] < 0:
		$HBox/SkillsFrame/Skills/Blade/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Blade/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Impact/Value.text = str(pc.dict["impact"])
	$HBox/SkillsFrame/Skills/Impact/Change.text = " (" + str(pc.dict["impact_change"]) + ")"
	if pc.dict["impact_change"] > 0:
		$HBox/SkillsFrame/Skills/Impact/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["impact_change"] < 0:
		$HBox/SkillsFrame/Skills/Impact/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Impact/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Flail/Value.text = str(pc.dict["flail"])
	$HBox/SkillsFrame/Skills/Flail/Change.text = " (" + str(pc.dict["flail_change"]) + ")"
	if pc.dict["flail_change"] > 0:
		$HBox/SkillsFrame/Skills/Flail/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["flail_change"] < 0:
		$HBox/SkillsFrame/Skills/Flail/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Flail/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Polearm/Value.text = str(pc.dict["polearm"])
	$HBox/SkillsFrame/Skills/Polearm/Change.text = " (" + str(pc.dict["polearm_change"]) + ")"
	if pc.dict["polearm_change"] > 0:
		$HBox/SkillsFrame/Skills/Polearm/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["polearm_change"] < 0:
		$HBox/SkillsFrame/Skills/Polearm/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Polearm/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Throw/Value.text = str(pc.dict["throw"])
	$HBox/SkillsFrame/Skills/Throw/Change.text = " (" + str(pc.dict["throw_change"]) + ")"
	if pc.dict["throw_change"] > 0:
		$HBox/SkillsFrame/Skills/Throw/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["throw_change"] < 0:
		$HBox/SkillsFrame/Skills/Throw/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Throw/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Bow/Value.text = str(pc.dict["bow"])
	$HBox/SkillsFrame/Skills/Bow/Change.text = " (" + str(pc.dict["bow_change"]) + ")"
	if pc.dict["bow_change"] > 0:
		$HBox/SkillsFrame/Skills/Bow/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["bow_change"] < 0:
		$HBox/SkillsFrame/Skills/Bow/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Bow/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Gun/Value.text = str(pc.dict["gun"])
	$HBox/SkillsFrame/Skills/Gun/Change.text = " (" + str(pc.dict["gun_change"]) + ")"
	if pc.dict["gun_change"] > 0:
		$HBox/SkillsFrame/Skills/Gun/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["gun_change"] < 0:
		$HBox/SkillsFrame/Skills/Gun/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Gun/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Shield/Value.text = str(pc.dict["shield"])
	$HBox/SkillsFrame/Skills/Shield/Change.text = " (" + str(pc.dict["shield_change"]) + ")"
	if pc.dict["shield_change"] > 0:
		$HBox/SkillsFrame/Skills/Shield/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["shield_change"] < 0:
		$HBox/SkillsFrame/Skills/Shield/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Shield/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Alchemy/Value.text = str(pc.dict["alchemy"])
	$HBox/SkillsFrame/Skills/Alchemy/Change.text = " (" + str(pc.dict["alchemy_change"]) + ")"
	if pc.dict["alchemy_change"] > 0:
		$HBox/SkillsFrame/Skills/Alchemy/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["alchemy_change"] < 0:
		$HBox/SkillsFrame/Skills/Alchemy/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Alchemy/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Religion/Value.text = str(pc.dict["religion"])
	$HBox/SkillsFrame/Skills/Religion/Change.text = " (" + str(pc.dict["religion_change"]) + ")"
	if pc.dict["religion_change"] > 0:
		$HBox/SkillsFrame/Skills/Religion/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["religion_change"] < 0:
		$HBox/SkillsFrame/Skills/Religion/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Religion/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Righteous/Value.text = str(pc.dict["righteous"])
	$HBox/SkillsFrame/Skills/Righteous/Change.text = " (" + str(pc.dict["righteous_change"]) + ")"
	if pc.dict["righteous_change"] > 0:
		$HBox/SkillsFrame/Skills/Righteous/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["righteous_change"] < 0:
		$HBox/SkillsFrame/Skills/Righteous/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Righteous/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Heal/Value.text = str(pc.dict["heal"])
	$HBox/SkillsFrame/Skills/Heal/Change.text = " (" + str(pc.dict["heal_change"]) + ")"
	if pc.dict["heal_change"] > 0:
		$HBox/SkillsFrame/Skills/Heal/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["heal_change"] < 0:
		$HBox/SkillsFrame/Skills/Heal/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Heal/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Latin/Value.text = str(pc.dict["latin"])
	$HBox/SkillsFrame/Skills/Latin/Change.text = " (" + str(pc.dict["latin_change"]) + ")"
	if pc.dict["latin_change"] > 0:
		$HBox/SkillsFrame/Skills/Latin/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["latin_change"] < 0:
		$HBox/SkillsFrame/Skills/Latin/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Latin/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/ReadWrite/Value.text = str(pc.dict["read_write"])
	$HBox/SkillsFrame/Skills/ReadWrite/Change.text = " (" + str(pc.dict["read_write_change"]) + ")"
	if pc.dict["read_write_change"] > 0:
		$HBox/SkillsFrame/Skills/ReadWrite/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["read_write_change"] < 0:
		$HBox/SkillsFrame/Skills/ReadWrite/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/ReadWrite/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Speak/Value.text = str(pc.dict["speak"])
	$HBox/SkillsFrame/Skills/Speak/Change.text = " (" + str(pc.dict["speak_change"]) + ")"
	if pc.dict["speak_change"] > 0:
		$HBox/SkillsFrame/Skills/Speak/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["speak_change"] < 0:
		$HBox/SkillsFrame/Skills/Speak/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Speak/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Trade/Value.text = str(pc.dict["trade"])
	$HBox/SkillsFrame/Skills/Trade/Change.text = " (" + str(pc.dict["trade_change"]) + ")"
	if pc.dict["trade_change"] > 0:
		$HBox/SkillsFrame/Skills/Trade/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["trade_change"] < 0:
		$HBox/SkillsFrame/Skills/Trade/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Trade/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Streetwise/Value.text = str(pc.dict["streetwise"])
	$HBox/SkillsFrame/Skills/Streetwise/Change.text = " (" + str(pc.dict["streetwise_change"]) + ")"
	if pc.dict["streetwise_change"] > 0:
		$HBox/SkillsFrame/Skills/Streetwise/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["streetwise_change"] < 0:
		$HBox/SkillsFrame/Skills/Streetwise/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Streetwise/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Artifice/Value.text = str(pc.dict["artifice"])
	$HBox/SkillsFrame/Skills/Artifice/Change.text = " (" + str(pc.dict["artifice_change"]) + ")"
	if pc.dict["artifice_change"] > 0:
		$HBox/SkillsFrame/Skills/Artifice/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["artifice_change"] < 0:
		$HBox/SkillsFrame/Skills/Artifice/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Artifice/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Riding/Value.text = str(pc.dict["riding"])
	$HBox/SkillsFrame/Skills/Riding/Change.text = " (" + str(pc.dict["riding_change"]) + ")"
	if pc.dict["riding_change"] > 0:
		$HBox/SkillsFrame/Skills/Riding/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["riding_change"] < 0:
		$HBox/SkillsFrame/Skills/Riding/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Riding/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))
	
	$HBox/SkillsFrame/Skills/Woodwise/Value.text = str(pc.dict["woodwise"])
	$HBox/SkillsFrame/Skills/Woodwise/Change.text = " (" + str(pc.dict["woodwise_change"]) + ")"
	if pc.dict["woodwise_change"] > 0:
		$HBox/SkillsFrame/Skills/Woodwise/Change.set("theme_override_colors/font_color", Color(0, 1, 0, 1))
	elif pc.dict["woodwise_change"] < 0:
		$HBox/SkillsFrame/Skills/Woodwise/Change.set("theme_override_colors/font_color", Color(1, 0, 0, 1))
	else:
		$HBox/SkillsFrame/Skills/Woodwise/Change.set("theme_override_colors/font_color", Color(0, 0, 0, 0))

func _on_notes_pressed():
	Main.pc_button_disable(0)
	Main.overlay_scene("res://main/notes_sheet.tscn")

#select item in party inventory
func _on_party_inventory_item_selected(index):
	item_selected = party_inventory.get_item_text(index)
	item_selected_index = index

func _on_party_inventory_item_activated(index):
	if item_selected.contains("\u0080"):
		swap_item(helmet_slot)
	elif item_selected.contains("\u0081"):
		swap_item(vest_slot)
	elif item_selected.contains("\u0082"):
		swap_item(leggings_slot)
	elif item_selected.contains("\u0083"):
		if main_weapon_slot.text == "Empty":
			swap_item(main_weapon_slot)
		elif side_arm_slot.text == "Empty":
			swap_item(side_arm_slot)
		else:
			swap_item(main_weapon_slot)
	elif item_selected.contains("\u0084"):
		swap_item(shield_slot)
	elif item_selected.contains("\u0086"):
		swap_item(ranged_weapon_slot)
	elif item_selected.contains("\u0087"):
		if potion_one_slot.text == "Empty":
			swap_item(potion_one_slot)
		elif potion_two_slot.text == "Empty":
			swap_item(potion_two_slot)
		else:
			swap_item(potion_one_slot)
	else:
			pass

# unequip items and put them into party inventory
func _on_helmet_slot_pressed():
	if item_selected != null and item_selected.contains("\u0080"):
		swap_item(helmet_slot)
	else:
		unequip_item(helmet_slot)

func _on_vest_slot_pressed():
	if item_selected != null and item_selected.contains("\u0081"):
		swap_item(vest_slot)
	else:
		unequip_item(vest_slot)

func _on_leggings_slot_pressed():
	if item_selected != null and item_selected.contains("\u0082"):
		swap_item(leggings_slot)
	else:
		unequip_item(leggings_slot)

func _on_main_weapon_slot_pressed():
	if item_selected != null and item_selected.contains("\u0083"):
		swap_item(main_weapon_slot)
	else:
		unequip_item(main_weapon_slot)

func _on_side_arm_slot_pressed():
	if item_selected != null and item_selected.contains("\u0083"):
		swap_item(side_arm_slot)
	else:
		unequip_item(side_arm_slot)

func _on_shield_slot_pressed():
	if item_selected != null and item_selected.contains("\u0084"):
		swap_item(shield_slot)
	else:
		unequip_item(shield_slot)

func _on_ranged_weapon_slot_pressed():
	if item_selected != null and item_selected.contains("\u0085"):
		swap_item(ranged_weapon_slot)
	else:
		unequip_item(ranged_weapon_slot)

func _on_potion_one_slot_pressed():
	if item_selected != null and item_selected.contains("\u0086"):
		swap_item(potion_one_slot)
	else:
		unequip_item(potion_one_slot)

func _on_potion_two_slot_pressed():
	if item_selected != null and item_selected.contains("\u0086"):
		swap_item(potion_two_slot)
	else:
		unequip_item(potion_two_slot)

#swaps item from party inventory into equipment slot
func swap_item(slot):
	item_equipped = slot.text
	slot.text = item_selected
	set_item_tooltip(slot)
	party_inventory.remove_item(item_selected_index)
	item_selected = null
	if not item_equipped.contains("Empty"):
		party_inventory.add_item(item_equipped, null, true)
	save_inventory()
	
#unequips item from equipment slot and puts back into party inventory
func unequip_item(slot):
	item_equipped = slot.text
	if item_equipped != "Empty":
		party_inventory.add_item(item_equipped, null, true)
		slot.text = "Empty"
	save_inventory()

func set_item_tooltip(slot):
	var item_name = slot.text
	if item_name != "Empty":
		var item_info = Data.get_node("Items").dict[item_name.get_slice("@", 0)]
		var weight = str(item_info["weight"])
		var value = str(item_info["value"])
		slot.tooltip_text = item_name + "\nWeight: " + weight + "\n" + "Value: " + value

func save_inventory():
	party_inventory.sort_items_by_text()
	inventory_data.clear()
	var i=0
	while i < party_inventory.item_count:
		inventory_data[str(i)] = party_inventory.get_item_text(i)
		i+=1
	pc.dict["helmet_slot"] = helmet_slot.text
	pc.dict["vest_slot"] = vest_slot.text
	pc.dict["leggings_slot"] = leggings_slot.text
	pc.dict["main_weapon_slot"] = main_weapon_slot.text
	pc.dict["side_arm_slot"] = side_arm_slot.text
	pc.dict["ranged_weapon_slot"] = ranged_weapon_slot.text
	pc.dict["shield_slot"] = shield_slot.text
	pc.dict["potion_one_slot"] = potion_one_slot.text
	pc.dict["potion_two_slot"] = potion_two_slot.text
	#this group call out refreshes inventories and item lists in shops
	get_tree().call_group("inventories", "refresh_shopping_inventories")

func _on_exit_pressed():
	Main.overlay_scene("res://main/empty.tscn")
	queue_free()
	Main.pc_button_disable(0)

