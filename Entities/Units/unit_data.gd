class_name UnitData extends Resource

@export var name := ""
@export var tooltip := ""
@export var uid := ""

@export var tier := 0
@export var price := 1

var level := 1
var experience := 0

@export var max_health := 100
@export var ability_power := 0
@export var ability_cd := 3.0 # counted in seconds

func _init(json : String = "") -> void:
	if json.is_empty(): return
	var data = JSON.parse_string(json)
	
	name = data["name"]
	tooltip = data["tooltip"]
	uid = data["uid"]
	tier = data["tier"]
	price = data["price"]
	level = data["level"]
	experience = data["experience"]
	max_health = data["max_health"]
	ability_power = data["ability_power"]
	ability_cd = data["ability_cd"]

func create_json() -> String:
	var stored_data = {
		"name" : name,
		"tooltip" : tooltip,
		"uid" : uid,
		"tier" : tier,
		"price" : price,
		"level" : level,
		"experience" : experience,
		"max_health" : max_health,
		"ability_power" : ability_power,
		"ability_cd" : ability_cd,
	}
	
	return JSON.stringify(stored_data)
	
