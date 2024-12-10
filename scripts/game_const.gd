extends Node

var green_slime: PackedScene = preload("res://scenes/enemies/slime_green.tscn")
var blue_slime: PackedScene = preload("res://scenes/enemies/slime_blue.tscn")

enum Enemy {
	GREEN_SLIME,
	BLUE_SLIME,
}

enum Tower {
	NONE,
	ARCHER,
	FIREBALL,
	ZAP,
}

var tower_labels: Dictionary = {
	Tower.ARCHER: "Archer Tower",
	Tower.FIREBALL: "Fireball Tower",
	Tower.ZAP: "Zap Tower",
}

# TODO: make this a dict of 2d arrays 
# { 1: [[enemy_type, amount], [enemy_type, amount], ...], 
#   2: [[enemy_type, amount], [enemy_type, amount], ...], ... }
var wave_data: Dictionary = {
	1: {
		Enemy.GREEN_SLIME: 5,
		Enemy.BLUE_SLIME: 0,
	},
	2: {
		Enemy.GREEN_SLIME: 10,
		Enemy.BLUE_SLIME: 0,
	},
	3: {
		Enemy.GREEN_SLIME: 5,
		Enemy.BLUE_SLIME: 5,
	},
	4: {
		Enemy.GREEN_SLIME: 10,
		Enemy.BLUE_SLIME: 10,
	},
	5: {
		Enemy.GREEN_SLIME: 0,
		Enemy.BLUE_SLIME: 15,
	},
	6: {
		Enemy.GREEN_SLIME: 25,
		Enemy.BLUE_SLIME: 10,
	},
	7: {
		Enemy.GREEN_SLIME: 5,
		Enemy.BLUE_SLIME: 20,
	},
}
var enemy_kill_awards: Dictionary = {
	Enemy.GREEN_SLIME: 10,
	Enemy.BLUE_SLIME: 20,
}
var enemy_objects: Dictionary = {
	Enemy.GREEN_SLIME: green_slime,
	Enemy.BLUE_SLIME: blue_slime,
}
var tower_costs: Dictionary = {
	Tower.ARCHER: 150,
	Tower.FIREBALL: 350,
	Tower.ZAP: 500,
}
# '2' is the cost to go from level 2 to level 3
var tower_upgrade_costs: Dictionary = {
	Tower.ARCHER: {
		2: 100,
		3: 200,
		4: 400,
	},
	Tower.FIREBALL: {
		2: 400,
		3: 700,
	},
	Tower.ZAP: {
		2: 600,
		3: 900,
	},
}
var tower_upgrade_descriptions: Dictionary = {
	Tower.ARCHER: {
		1: "Base stats",
		2: "Attack range +33%",
		3: "Arrow pierce +1",
		4: "Attack rate +100%",
		#5: "Max level reached!",
	},
	Tower.FIREBALL: {
		1: "Base stats",
		2: "Increase attack rate by 100%",
		3: "fireball tower lvl 3",
		#4: "Max level reached!",
	},
	Tower.ZAP: {
		1: "Base stats",
		2: "Increase attack rate by 100%",
		3: "zap tower tower lvl 3",
		#4: "Max level reached!",
	},
}
var tower_level_data: Dictionary = {
	Tower.ARCHER: {
		1: {
			"attack_range": 90,
			"attack_rate": 1.4,
			"pierce": 1,
		},
		2: {
			"attack_range": 120,
			"attack_rate": 1.4,
			"pierce": 1,
		},
		3: {
			"attack_range": 120,
			"attack_rate": 1.4,
			"pierce": 2,
		},
		4: {
			"attack_range": 120,
			"attack_rate": 0.7,
			"pierce": 2,
		},
	},
	Tower.FIREBALL: {
		1: {
			"attack_range": 60,
			"attack_rate": 2.8,
		},
		2: {
			"attack_range": 60,
			"attack_rate": 1.4,
		},
		3: {
			"attack_range": 60,
			"attack_rate": 0.9,
		},
	},
	Tower.ZAP: {
		1: {
			"attack_range": 70,
			"attack_rate": 4.5,
		},
		2: {
			"attack_range": 70,
			"attack_rate": 2.25,
		},
		3: {
			"attack_range": 70,
			"attack_rate": 1.5,
		},
	},
}
const wave_award = 100

