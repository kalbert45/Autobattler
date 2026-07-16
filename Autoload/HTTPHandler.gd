extends Node

@export var http: AwaitableHTTPRequest

var endpoint = "https://firestore.googleapis.com/v1beta1/projects/autobattler-6b7e5/databases/(default)/documents/"
var collection = "ghosts"

func post_ghost() -> void:
	if Global.debug & Global.DEBUG_FLAGS.DISABLE_POST_GHOST:
		return
	
	var ghost_data = {
		"name" : "",
		"fields" : {
			"ROUND" : {
				"integerValue" : GameState.ROUND,
			},
			"Board" : {
				"stringValue" : GameState.get_player_board_json(),
			},
		},
	}
	
	var ghost_data_json = JSON.stringify(ghost_data)
	
	var result = await http.async_request(endpoint + collection, [], HTTPClient.Method.METHOD_POST, ghost_data_json)
	
	
	#print(result.body_as_string())
	
func get_ghost_board() -> Dictionary[Vector2i, UnitData]:
	var query_json = {
		"structuredQuery" : {
			"from" : {
				"collectionId" : "ghosts",
			},
			"where" : {
				"fieldFilter" : {
					"field" : {
						"fieldPath" : "ROUND"
					},
					"op" : 5,
					"value" : {
						"integerValue" : GameState.ROUND
					}
				}
			},
			"limit" : 1,
		}
	}
	
	var result = await http.async_request(endpoint + ":runQuery", [], HTTPClient.Method.METHOD_POST, JSON.stringify(query_json))
	var result_dict = JSON.parse_string(result.body_as_string())
	print(result_dict)
	var board_json = ""
	if result_dict[0].has("document"):
		board_json = result_dict[0]["document"]["fields"]["Board"]["stringValue"]
	return GameState.load_board_json(board_json)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#post_ghost()
	
