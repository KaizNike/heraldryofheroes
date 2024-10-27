## The Resource for baseline character statistics, 
## each one to be extended and saved in "res://data/character_data/stats/"
class_name Statistic
extends Resource

@export var stat_name := ""
@export var stat_max: int = 0
@export var stat_value: int = 0:
	set(value):
		if stat_value > stat_max:
			stat_value = stat_max
@export var stat_change: int = 0
@export var affecting_age: int = 0 ## Changes the starting value, based on pc.gd. 
## Ex: var charisma = 10 - abs(age-40)/factor, 40 would be affecting age.

## Base setup for stats, can be overriden by writing 'return 0' at the end of a
## different character_setup in the stat script.
func character_setup(age: int):
	var factor = 2
	var stat_start = 10 - abs(age - affecting_age) / factor
	stat_max = stat_start
	stat_value = stat_start

## A more complex setter for when you want to update both at once. 
func update_stat_max_and_value(value):
	stat_value = value
	stat_max = value
	
