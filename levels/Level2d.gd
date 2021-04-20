extends Node2D

var astar: AStar2D

func _ready():
	astar = $PathFinder.get_astar_4_tile_map($Ground)
	print(astar.get_points())
