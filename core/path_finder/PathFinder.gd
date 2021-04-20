extends Node
class_name PathFinder


func get_astar_4_tile_map(tile_map: TileMap) -> AStar2D:
	var TILE_ADJ = tile_map.cell_size / 2 # Смещение к центру тайла
	var astar = AStar2D.new()
	var cells = tile_map.get_used_cells()
	cells.sort() # Сортруем тайлы по X и Y координатам
	
	for i in range(cells.size()):
		var cell = cells[i]
		 # Регистрируем точку (Vector2) в центре тайла как узел Astar
		astar.add_point(i, tile_map.map_to_world(cell) + TILE_ADJ)
		
		# Массив сосединх точек для соединения узлов Astar
		var neighbours = [ 
			Vector2(cell.x, cell.y - 1), # top cell
			Vector2(cell.x - 1, cell.y), # left cell
#			Vector2(cell.x - 1, cell.y - 1) # top left cell
		]
		
		for neghbour in neighbours:
			if tile_map.get_cellv(neghbour) == TileMap.INVALID_CELL:
				continue
			astar.connect_points(i, astar.get_closest_point(tile_map.map_to_world(neghbour) + TILE_ADJ))
	
	return astar
