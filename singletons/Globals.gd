extends Node

var game_started = false
var autostarttext = true
var intro_done = false

var deathcause = null 
var dayssurvived = 0
var healthy = true
var sickdaysleft = 0
var hunger = 3
var thirst = 3
var tree = 0
var soilwatered = false
var appleinsoil = false
var timeswatered = 0
var soilstep = 0

func reset():
	game_started = false
	autostarttext = true
	intro_done = false
	deathcause = null 
	dayssurvived = 0
	healthy = true
	sickdaysleft = 0
	hunger = 3
	thirst = 3
	tree = 0 
	soilstep = 0
	soilwatered = false
	appleinsoil = false
	timeswatered = 0

func getseason():
	if dayssurvived <5: return "spring"
	elif dayssurvived >= 5 and dayssurvived < 10: return "summer"
	elif dayssurvived >= 10 and dayssurvived < 15: return "autumn"
	elif dayssurvived >= 14 and dayssurvived < 20: return "winter"
	else: return "spring"
	
func stats():
	var array = []
	array.append("Healthy") if healthy else array.append("Sick")
	for i in [hunger, thirst]:
		match i:
			1: array.append("Bad")
			2: array.append("Good")
			3: array.append("Perfect")
			_: array.append("Horrible")
	match tree:
		0: array.append("None")
		1: array.append("Min")
		2: array.append("Mid")
		3: array.append("Max")
	return array
