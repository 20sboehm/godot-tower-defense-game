extends Node

enum EnemyType {
	GREEN_SLIME,
	BLUE_SLIME,
	TANK_SLIME,
}

enum TowerType {
	NONE,
	ARCHER,
	FIREBALL,
	ZAP,
}

var upgrade_data: Dictionary = {
	"start_gold": {
		1: {
			"upgrade_cost": 0,
			"value": 200,
		},
		2: {
			"upgrade_cost": 10,
			"value": 400,
		},
		3: {
			"upgrade_cost": 20,
			"value": 600,
		},
		4: {
			"upgrade_cost": 40,
			"value": 900,
		},
		5: {
			"upgrade_cost": 60,
			"value": 1200,
		},
		6: {
			"upgrade_cost": 90,
			"value": 1600,
		},
		7: {
			"upgrade_cost": 120,
			"value": 2000,
		},
		8: {
			"upgrade_cost": 160,
			"value": 2500,
		},
		9: {
			"upgrade_cost": 200,
			"value": 3000,
		},
		10: {
			"upgrade_cost": 250,
			"value": 3600,
		},
	}
}

# TODO: make this const?
var level_wave_data: Dictionary = {
	# Level
	1: {
		# Wave
		1: [
			# Phase
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 5,
				"wait_time": 0.6
			},
		],
		2: [
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 10,
				"wait_time": 0.6
			},
		],
		3: [
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 5,
				"wait_time": 0.6
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 5,
				"wait_time": 0.6
			},
		],
		4: [
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 5,
				"wait_time": 0.6
			},
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 5,
				"wait_time": 0.6
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 5,
				"wait_time": 0.6
			},
		],
		5: [
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 20,
				"wait_time": 0.6
			},
		],
		6: [
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 30,
				"wait_time": 0.15
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 30,
				"wait_time": 0.5
			},
		],
		7: [
			{
				"enemy_type": EnemyType.TANK_SLIME,
				"count": 1,
				"wait_time": 2.0
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 30,
				"wait_time": 0.15
			},
			{
				"enemy_type": EnemyType.TANK_SLIME,
				"count": 1,
				"wait_time": 2.0
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 30,
				"wait_time": 0.15
			},
			{
				"enemy_type": EnemyType.TANK_SLIME,
				"count": 1,
				"wait_time": 2.0
			},
		],
		8: [
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 50,
				"wait_time": 0.4
			},
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 20,
				"wait_time": 0.2
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 50,
				"wait_time": 0.4
			},
		],
		9: [
			{
				"enemy_type": EnemyType.TANK_SLIME,
				"count": 25,
				"wait_time": 1.2
			},
		],
		10: [
			{
				"enemy_type": EnemyType.TANK_SLIME,
				"count": 20,
				"wait_time": 0.8
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 80,
				"wait_time": 0.2
			},
		],
	}
}

## Enemy Data
var e_data: Dictionary = {
	EnemyType.GREEN_SLIME: {
		"hp": 1,
		"speed": 0.06,
		"tower_damage": 1,
		"label": "Green Slime",
		"gold_award": 5,
		"rp_award": 1,
	},
	EnemyType.BLUE_SLIME: {
		"hp": 3,
		"speed": 0.07,
		"tower_damage": 2,
		"label": "Blue Slime",
		"gold_award": 10,
		"rp_award": 2,
	},
	EnemyType.TANK_SLIME: {
		"hp": 15,
		"speed": 0.05,
		"tower_damage": 3,
		"label": "Tank Slime",
		"gold_award": 15,
		"rp_award": 3,
	},
}

## Tower Data
var t_data: Dictionary = {
	TowerType.ARCHER: {
		"cost": 200,
		"label": "Archer Tower",
		"lvl_data": {
			1: {
				"upgrade_cost": 0,
				"upgrade_desc": "Base stats",
				"stats": {
					"damage": 1,
					"attack_range": 90,
					"attack_rate": 1.4,
					"pierce": 1,
				},
			},
			2: {
				"upgrade_cost": 100,
				"upgrade_desc": "Attack range +33%",
				"stats": {
					"damage": 1,
					"attack_range": 120,
					"attack_rate": 1.4,
					"pierce": 1,
				},
			},
			3: {
				"upgrade_cost": 250,
				"upgrade_desc": "Arrow pierce +1",
				"stats": {
					"damage": 1,
					"attack_range": 120,
					"attack_rate": 1.4,
					"pierce": 2,
				},
			},
			4: {
				"upgrade_cost": 400,
				"upgrade_desc": "Attack delay 1.4s -> 0.7s (-50%)",
				"stats": {
					"damage": 1,
					"attack_range": 120,
					"attack_rate": 0.7,
					"pierce": 2,
				},
			},
		},
	},
	TowerType.FIREBALL: {
		"cost": 550,
		"label": "Fireball Tower",
		"lvl_data": {
			1: {
				"upgrade_cost": 0,
				"upgrade_desc": "Base stats",
				"stats": {
					"damage": 1,
					"attack_range": 60,
					"attack_rate": 2.7,
				},
			},
			2: {
				"upgrade_cost": 450,
				"upgrade_desc": "Damage +1",
				"stats": {
					"damage": 2,
					"attack_range": 60,
					"attack_rate": 2.7,
				},
			},
			3: {
				"upgrade_cost": 700,
				"upgrade_desc": "Attack delay 2.7s -> 1.6s (-40%)",
				"stats": {
					"damage": 2,
					"attack_range": 60,
					"attack_rate": 1.6,
				},
			},
		},
	},
	TowerType.ZAP: {
		"cost": 350,
		"label": "Zap Tower",
		"lvl_data": {
			1: {
				"upgrade_cost": 0,
				"upgrade_desc": "Base stats",
				"stats": {
					"damage": 1,
					"attack_range": 70,
					"attack_rate": 3.6,
					"zap_count": 3,
				},
			},
			2: {
				"upgrade_cost": 250,
				"upgrade_desc": "+2 zap chain",
				"stats": {
					"damage": 1,
					"attack_range": 70,
					"attack_rate": 3.6,
					"zap_count": 5,
				},
			},
			3: {
				"upgrade_cost": 450,
				"upgrade_desc": "Attack delay 3.6s -> 2.2s (-40%)",
				"stats": {
					"damage": 1,
					"attack_range": 70,
					"attack_rate": 2.2,
					"zap_count": 5,
				},
			},
		},
	},
}

const wave_award = 100
