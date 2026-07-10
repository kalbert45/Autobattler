extends Node

const ALL_UNIT_DATA_RESOURCE = preload("res://Entities/Units/ALL_UNIT_DATA.tres")

var _all_unit_data : Array[UnitData]


func _ready() -> void:
	ALL_UNIT_DATA_RESOURCE.load_all_into(_all_unit_data)

func get_unit_data_pool(num : int, tier_range : Array[int], tag_flags : int) -> Array[UnitData]:
	# TODO filter
	var filtered_data = _all_unit_data.filter(_filter_unit_data_method.bind(tier_range, tag_flags))
	filtered_data.shuffle() 
	
	return filtered_data.slice(0, num)
	
func _filter_unit_data_method(data : UnitData, tier_range : Array[int], tag_flags : int) -> bool:
	return true

#----------------------------------------------------------------

func get_item_data_pool(num : int, tier_range : Array[int], tag_flags : int) -> Array[UnitData]:
	# TODO filter
	var filtered_data = _all_unit_data.filter(_filter_unit_data_method.bind(tier_range, tag_flags))
	filtered_data.shuffle() 
	
	return filtered_data.slice(0, num)
	
func _filter_item_data_method(data : UnitData, tier_range : Array[int], tag_flags : int) -> bool:
	return true
	
#-----------------------

#func get_artifacts_pool(num_artifacts : int, tier_range : Array[int], tag_flags : int) -> Array:
	#return []
	#
#func _filter_artifact_method(data : CardData, tier_range : Array[int], tag_flags : int) -> bool:
	#return false
