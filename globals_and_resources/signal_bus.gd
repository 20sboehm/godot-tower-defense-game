extends Node

# Enemies
signal enemy_killed(enemy: GameC.EnemyType)

# Tower building
signal update_building_selection(tower: GameC.TowerType)

# Level/Wave management
signal wave_start
signal done_spawning
#signal level_over(win_or_loss: String) # "win" or "loss"

# Tower selection
signal click_tower(tower: Tower)

# Tower upgrade
signal upgrade_tower

# Tower sell
signal sell_tower
