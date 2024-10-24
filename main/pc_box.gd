extends Button

@onready var first_name = get_node("HBox/CharBox/Name")
@onready var portrait = get_node("HBox/CharBox/PortraitFrame/Portrait")
@onready var end_bar = get_node("HBox/StatsBox/EndBox/EndBar")
@onready var end_val = get_node("HBox/StatsBox/EndBox/EndVal")
@onready var str_bar = get_node("HBox/StatsBox/StrBox/StrBar")
@onready var str_val = get_node("HBox/StatsBox/StrBox/StrVal")
@onready var bls_bar = get_node("HBox/StatsBox/BlsBox/BlsBar")
@onready var bls_val = get_node("HBox/StatsBox/BlsBox/BlsVal")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func update_box(pc):
	var pc_button = Main.get_node("HBox/Party/" + pc + "Frame/" + pc)
	var pc_data = Data.get_node(pc)
	if pc_data.dict["first_name"] == null:
		return
	else:
		pc_button.portrait.texture = load(pc_data.dict["portrait"])
		pc_button.first_name.text = pc_data.dict["first_name"]
		pc_button.end_bar.max_value = pc_data.dict["endurance_max"]
		pc_button.end_bar.value = pc_data.dict["endurance"]
		pc_button.end_val.text = str(pc_data.dict["endurance"])
		pc_button.str_bar.max_value = pc_data.dict["strength_max"]
		pc_button.str_bar.value = pc_data.dict["strength"]
		pc_button.str_val.text = str(pc_data.dict["strength"])
		pc_button.bls_bar.max_value = pc_data.dict["blessing_max"]
		pc_button.bls_bar.value = pc_data.dict["blessing"]
		pc_button.bls_val.text = str(pc_data.dict["blessing"])
		pc_button.visible = true
		pc_button.disabled = false
