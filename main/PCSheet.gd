extends TextureRect

#shortcuts for accessing nodes
@onready var party_stats = get_node("HBox/PartyStatsFrame")
@onready var party_inventory = get_node("HBox/InventoryFrame/PartyInventory")
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

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("HBox/InventoryFrame/Money").text = str(Data.stats["money"]) + "$"
	
	for i in Data.inventory:
		party_inventory.add_item(Data.inventory[i], null, true)
	
	if Main.get_node("HBox/Party/PC1Frame/PC1").disabled == true:
		player = Data.get_node("PC1")
	elif Main.get_node("HBox/Party/PC2Frame/PC2").disabled == true:
		player = Data.get_node("PC2")
	elif Main.get_node("HBox/Party/PC3Frame/PC3").disabled == true:
		player = Data.get_node("PC3")
	elif Main.get_node("HBox/Party/PC4Frame/PC4").disabled == true:
		player = Data.get_node("PC4")
	elif Main.get_node("HBox/Party/PC5Frame/PC5").disabled == true:
		player = Data.get_node("PC5")
	
	helmet_slot.add_item(player.dict["helmet_slot"], null, false)
	set_item_tooltip(helmet_slot)
	vest_slot.add_item(player.dict["vest_slot"], null, false)
	set_item_tooltip(vest_slot)
	leggings_slot.add_item(player.dict["leggings_slot"], null, false)
	set_item_tooltip(leggings_slot)
	main_weapon_slot.add_item(player.dict["main_weapon_slot"], null, false)
	set_item_tooltip(main_weapon_slot)
	side_arm_slot.add_item(player.dict["side_arm_slot"], null, false)
	set_item_tooltip(side_arm_slot)
	shield_slot.add_item(player.dict["shield_slot"], null, false)
	set_item_tooltip(shield_slot)
	ranged_weapon_slot.add_item(player.dict["ranged_weapon_slot"], null, false)
	set_item_tooltip(ranged_weapon_slot)
	potion_one_slot.add_item(player.dict["potion_one_slot"], null, false)
	set_item_tooltip(potion_one_slot)
	potion_two_slot.add_item(player.dict["potion_two_slot"], null, false)
	set_item_tooltip(potion_two_slot)
	
	$HBox/CharacterFrame/Character/Name.text = player.dict["first_name"] + " " + player.dict["last_name"]
	var day = player.dict["birthday"].get_slice("/",0)
	if day == "1" or day == "21" or day == "31":
		day = day + "st"
	elif day == "2" or day == "22":
		day = day + "nd"
	elif day == "3" or day == "23":
		day = day + "rd"
	else:
		day = day + "th"
	var month = player.dict["birthday"].get_slice("/",1)
	match month:
		"1":
			month = "January"
		"2":
			month = "February"
		"3":
			month = "March"
		"4":
			month = "April"
		"5":
			month = "May"
		"6":
			month = "June"
		"7":
			month = "July"
		"8":
			month = "August"
		"9":
			month = "September"
		"10":
			month = "October"
		"11":
			month = "November"
		"12":
			month = "December"
	var year = player.dict["birthday"].get_slice("/",2)
	$HBox/CharacterFrame/Character/Birthday.text = "Born " + day + " " + month + " " + year + "..."
	$HBox/CharacterFrame/Character/Birthplace.text = "...in " + player.dict["birthplace"]
	$HBox/SkillsFrame/Skills/Endurance.text = "Endurance  " + str(player.dict["endurance"])
	$HBox/SkillsFrame/Skills/Strength.text = "Strength  " + str(player.dict["strength"])
	$HBox/SkillsFrame/Skills/Agility.text = "Agility  " + str(player.dict["agility"])
	$HBox/SkillsFrame/Skills/Intelligence.text = "Intelligence  " + str(player.dict["intelligence"])
	$HBox/SkillsFrame/Skills/Perception.text = "Perception  " + str(player.dict["perception"])
	$HBox/SkillsFrame/Skills/Charisma.text = "Charisma  " + str(player.dict["charisma"])
	
	$HBox/SkillsFrame/Skills/Sword.text = "Sword  " + str(player.dict["blade"])
	$HBox/SkillsFrame/Skills/Impact.text = "Impact  " + str(player.dict["impact"])
	$HBox/SkillsFrame/Skills/Flail.text = "Flail  " + str(player.dict["flail"])
	$HBox/SkillsFrame/Skills/Polearm.text = "Polearm  " + str(player.dict["polearm"])
	$HBox/SkillsFrame/Skills/Throw.text = "Throw  " + str(player.dict["throw"])
	$HBox/SkillsFrame/Skills/Bow.text = "Bow  " + str(player.dict["bow"])
	$HBox/SkillsFrame/Skills/Gun.text = "Gun  " + str(player.dict["gun"])
	$HBox/SkillsFrame/Skills/Shield.text = "Shield  " + str(player.dict["shield"])
	$HBox/SkillsFrame/Skills/Alchemy.text = "Alchemy  " + str(player.dict["alchemy"])
	$HBox/SkillsFrame/Skills/Religion.text = "Religion  " + str(player.dict["religion"])
	$HBox/SkillsFrame/Skills/Righteous.text = "Righteousness  " + str(player.dict["righteous"])
	$HBox/SkillsFrame/Skills/Heal.text = "Heal  " + str(player.dict["heal"])
	$HBox/SkillsFrame/Skills/Latin.text = "Latin  " + str(player.dict["latin"])
	$HBox/SkillsFrame/Skills/ReadWrite.text = "Read and Write  " + str(player.dict["read_write"])
	$HBox/SkillsFrame/Skills/Speaking.text = "Speaking  " + str(player.dict["speaking"])
	$HBox/SkillsFrame/Skills/Trade.text = "Trade  " + str(player.dict["trade"])
	$HBox/SkillsFrame/Skills/Streetwise.text = "Streetwise  " + str(player.dict["streetwise"])
	$HBox/SkillsFrame/Skills/Artifice.text = "Artifice  " + str(player.dict["artifice"])
	$HBox/SkillsFrame/Skills/Riding.text = "Riding  " + str(player.dict["riding"])
	$HBox/SkillsFrame/Skills/Woodwise.text = "Woodwise  " + str(player.dict["woodwise"])

#handling keyboard input
func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed():
		get_viewport().set_input_as_handled()
		
		#press escape to exit the player character sheet back to the game
		if event.keycode == KEY_ESCAPE:
			Main.overlay_scene("res://main/Empty.tscn")
			#sets all pc buttons on left side to enabled
			Main.pc_button_disable(0)
			queue_free()

#select item in party inventory
func _on_party_inventory_item_selected(index):
	item_selected = party_inventory.get_item_text(index)
	item_selected_index = index

func _on_party_inventory_item_activated():
	if item_selected.contains("\u0080"):
		swap_item(helmet_slot)
	elif item_selected.contains("\u0081"):
		swap_item(vest_slot)
	elif item_selected.contains("\u0082"):
		swap_item(leggings_slot)
	elif item_selected.contains("\u0083"):
		if main_weapon_slot.get_item_text(0).contains("Empty"):
			swap_item(main_weapon_slot)
		elif side_arm_slot.get_item_text(0).contains("Empty"):
			swap_item(side_arm_slot)
		else:
			swap_item(main_weapon_slot)
	elif item_selected.contains("\u0084"):
		swap_item(shield_slot)
	elif item_selected.contains("\u0085"):
		swap_item(ranged_weapon_slot)
	elif item_selected.contains("\u0086"):
		if potion_one_slot.get_item_text(0).contains("Empty"):
			swap_item(potion_one_slot)
		elif potion_two_slot.get_item_text(0).contains("Empty"):
			swap_item(potion_two_slot)
		else:
			swap_item(potion_one_slot)
	else:
			pass

# unequip items and put them into party inventory
func _on_helmet_slot_item_clicked():
	if item_selected != null and item_selected.contains("\u0080"):
		swap_item(helmet_slot)
	else:
		unequip_item(helmet_slot)

func _on_vest_slot_item_clicked():
	if item_selected != null and item_selected.contains("\u0081"):
		swap_item(vest_slot)
	else:
		unequip_item(vest_slot)

func _on_leggings_slot_item_clicked():
	if item_selected != null and item_selected.contains("\u0082"):
		swap_item(leggings_slot)
	else:
		unequip_item(leggings_slot)

func _on_main_weapon_slot_item_clicked():
	if item_selected != null and item_selected.contains("\u0083"):
		swap_item(main_weapon_slot)
	else:
		unequip_item(main_weapon_slot)

func _on_side_arm_slot_item_clicked():
	if item_selected != null and item_selected.contains("\u0083"):
		swap_item(side_arm_slot)
	else:
		unequip_item(side_arm_slot)

func _on_shield_slot_item_clicked():
	if item_selected != null and item_selected.contains("\u0084"):
		swap_item(shield_slot)
	else:
		unequip_item(shield_slot)

func _on_ranged_weapon_slot_item_clicked():
	if item_selected != null and item_selected.contains("\u0085"):
		swap_item(ranged_weapon_slot)
	else:
		unequip_item(ranged_weapon_slot)

func _on_potion_one_slot_item_clicked():
	if item_selected != null and item_selected.contains("\u0086"):
		swap_item(potion_one_slot)
	else:
		unequip_item(potion_one_slot)

func _on_potion_two_slot_item_clicked():
	if item_selected != null and item_selected.contains("\u0086"):
		swap_item(potion_two_slot)
	else:
		unequip_item(potion_two_slot)

#swaps item from party inventory into equipment slot
func swap_item(slot):
	item_equipped = slot.get_item_text(0)
	slot.clear()
	slot.add_item(item_selected, null, false)
	set_item_tooltip(slot)
	party_inventory.remove_item(item_selected_index)
	item_selected = null
	if not item_equipped.contains("Empty"):
		party_inventory.add_item(item_equipped, null, true)
	save_inventory()
	
#unequips item from equipment slot and puts back into party inventory
func unequip_item(slot):
	item_equipped = slot.get_item_text(0)
	if not item_equipped.contains("Empty"):
		party_inventory.add_item(item_equipped, null, true)
		slot.clear()
		slot.add_item("Empty", null, false)
	save_inventory()

func set_item_tooltip(slot):
	var item_name = slot.get_item_text(0)
	if item_name != "Empty":
		var item_info = Data.get_node("Items").item_dict[item_name]
		var weight = item_info.get_slice("/",0)
		var value = item_info.get_slice("/",1)
		slot.set_item_tooltip(0, item_name + "\nWeight: " + weight + "\n" + "Value: " + value)

func save_inventory():
	party_inventory.sort_items_by_text()
	Data.inventory.clear()
	var i=0
	while i < party_inventory.item_count:
		Data.inventory[str(i)] = party_inventory.get_item_text(i)
		i+=1
	player.dict["helmet_slot"] = helmet_slot.get_item_text(0)
	player.dict["vest_slot"] = vest_slot.get_item_text(0)
	player.dict["leggings_slot"] = leggings_slot.get_item_text(0)
	player.dict["main_weapon_slot"] = main_weapon_slot.get_item_text(0)
	player.dict["side_arm_slot"] = side_arm_slot.get_item_text(0)
	player.dict["ranged_weapon_slot"] = ranged_weapon_slot.get_item_text(0)
	player.dict["shield_slot"] = shield_slot.get_item_text(0)
	player.dict["potion_one_slot"] = potion_one_slot.get_item_text(0)
	player.dict["potion_two_slot"] = potion_two_slot.get_item_text(0)
	#this group call out refreshes inventories and item lists in shops
	get_tree().call_group("inventories", "refresh_shopping_inventories")

