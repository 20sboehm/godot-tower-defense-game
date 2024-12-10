extends Node

# Enemies
signal enemy_killed(enemy: GameConst.Enemy)

# Tower building
signal update_building_selection(tower: GameConst.Tower)

# Wave management
signal wave_start

# Tower selection
signal click_tower(tower: Tower)

# Tower upgrade
signal upgrade_tower

# Tower sell
signal sell_tower
