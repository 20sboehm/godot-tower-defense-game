extends Node

# Enemies
signal enemy_killed(enemy: GameC.EnemyType)

# Tower building
signal update_building_selection(tower: GameC.TowerType)

# Wave management
signal wave_start
signal done_spawning

# Tower selection
signal click_tower(tower: Tower)

# Tower upgrade
signal upgrade_tower

# Tower sell
signal sell_tower
