extends TileMap

func is_buildable(pos: Vector2) -> bool:
	var cell: Vector2i = local_to_map(pos)
	var data: TileData = get_cell_tile_data(0, cell)
	return data.get_custom_data("buildable")
