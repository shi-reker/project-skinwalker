extends Node

var house_nodes: Array[House] = []

enum HouseColor {RED, BLACK, WHITE}
var color_houses: Dictionary[HouseColor, Array] = {} # [house_node1, house_node2]

var home_node: House = null

class HomeHints:
	var is_color_guessed: bool = false
	var color: EnvironmentManager.HouseColor
	var is_street_guessed: bool = false
	var street: Street

var street_nodes: Array[Street] = []
var street_houses: Dictionary[Street, Array] = {} # street_node: [house_node1, house_node2]

func set_home(house: House) -> void:
	if not is_instance_valid(house):
		push_error("Cannot set an invalid home house.")
		return

	add_house(house)
	home_node = house

func add_house(house: House) -> void:
	if not is_instance_valid(house) or house in house_nodes:
		return

	house_nodes.append(house)

	if not color_houses.has(house.color):
		color_houses[house.color] = []
	color_houses[house.color].append(house)

	if is_instance_valid(house.street):
		add_street(house.street)
		if not street_houses.has(house.street):
			street_houses[house.street] = []
		street_houses[house.street].append(house)

	if house.is_home:
		home_node = house

func add_street(street: Street) -> void:
	if not is_instance_valid(street) or street in street_nodes:
		return
	street_nodes.append(street)

func get_candidates(hints: HomeHints) -> Array[House]:
	var candidates: Array[House] = []
	for house in house_nodes:
		if not is_instance_valid(house):
			continue
		if hints != null and hints.is_color_guessed and house.color != hints.color:
			continue
		if hints != null and hints.is_street_guessed and house.street != hints.street:
			continue
		candidates.append(house)
	return candidates

func get_candidates_pos(hints: HomeHints) -> Array[Vector2]:
	var candidates_pos: Array[Vector2] = []
	for house in get_candidates(hints):
		candidates_pos.append(house.global_position)
	return candidates_pos

func reveal_hints(hints: HomeHints) -> HomeHints:
	if not is_instance_valid(home_node):
		push_error("Cannot reveal stalker hints before the home is set.")
		return hints

	if hints.is_color_guessed:
		hints.color = home_node.color
	if hints.is_street_guessed:
		hints.street = home_node.street
	return hints
