extends Node2D

func _ready():
	return
	var navigation = get_node("Environment/Navigation")
	var tilemap = navigation.get_node("TileMap")
	
	var navpoly = NavigationPolygon.new()
	var cell_half_size = tilemap.cell_size / 2
	var cell_half_size2 = Vector2(-cell_half_size.x, cell_half_size.y)
	navpoly.set_vertices([ -cell_half_size, cell_half_size2, cell_half_size, -cell_half_size2 ])
	navpoly.add_outline([ -cell_half_size, cell_half_size2, cell_half_size, -cell_half_size2 ])
	navpoly.make_polygons_from_outlines()
	
	var start = tilemap.get_used_rect().position
	
	var cells = tilemap.get_used_cells()
	for cell_position in cells:
		var cell = tilemap.get_cell(cell_position.x, cell_position.y)
		var shape = tilemap.tile_set.tile_get_shape(cell, 0)
		if shape != null:
			var navigation_polygon = get_node("NavigationPolygonTemplate").duplicate()
			#navigation_polygon.navpoly = navpoly
			navigation_polygon.position = start + Vector2(cell_position.x * tilemap.cell_size.x, cell_position.y * tilemap.cell_size.y)
			var pos = navigation_polygon.position
			navigation.add_child(navigation_polygon)