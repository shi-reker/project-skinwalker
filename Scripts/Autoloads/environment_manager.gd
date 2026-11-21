extends Node

var house_nodes: Array[House] = []

enum HouseColor {RED, BLACK, WHITE}
var color_houses: Dictionary[HouseColor, Array] = {} # [house_node1, house_node2]

var home_node: House = null

func add_house(house: House):
	if house in house_nodes:
		return
	house_nodes.append(house)
	
	var house_color: HouseColor = house.color
	color_houses[house_color].append(house)
	
	
func add_street(street: Street):
	if street in street_nodes:
		return
	street_nodes.append(street)

