extends Node

#var green_slime: PackedScene = preload("res://scenes/enemies/slime_green.tscn")
#var blue_slime: PackedScene = preload("res://scenes/enemies/slime_blue.tscn")
#var tank_slime: PackedScene = preload("res://scenes/enemies/slime_tank.tscn")

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
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 20,
				"wait_time": 0.5
			},
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 30,
				"wait_time": 0.3
			},
		],
		7: [
			{
				"enemy_type": EnemyType.TANK_SLIME,
				"count": 1,
				"wait_time": 2.0
			},
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 40,
				"wait_time": 0.15
			},
			{
				"enemy_type": EnemyType.TANK_SLIME,
				"count": 1,
				"wait_time": 2.0
			},
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 40,
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
				"count": 25,
				"wait_time": 0.4
			},
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 20,
				"wait_time": 0.2
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 25,
				"wait_time": 0.4
			},
		],
		9: [
			{
				"enemy_type": EnemyType.TANK_SLIME,
				"count": 10,
				"wait_time": 1.2
			},
		],
		10: [
			{
				"enemy_type": EnemyType.TANK_SLIME,
				"count": 10,
				"wait_time": 0.8
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 25,
				"wait_time": 0.3
			},
		],
	}
}

## Enemy Data
var e_data: Dictionary = {
	EnemyType.GREEN_SLIME: {
		#"scene": green_slime,
		"hp": 1,
		"speed": 0.06,
		"tower_damage": 1,
		"label": "Green Slime",
		"kill_award": 10,
	},
	EnemyType.BLUE_SLIME: {
		#"scene": blue_slime,
		"hp": 3,
		"speed": 0.07,
		"tower_damage": 2,
		"label": "Blue Slime",
		"kill_award": 20,
	},
	EnemyType.TANK_SLIME: {
		#"scene": tank_slime,
		"hp": 15,
		"speed": 0.05,
		"tower_damage": 3,
		"label": "Tank Slime",
		"kill_award": 50,
	},
}

## Tower Data
var t_data: Dictionary = {
	TowerType.ARCHER: {
		"cost": 150,
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
				"upgrade_cost": 80,
				"upgrade_desc": "Attack range +33%",
				"stats": {
					"damage": 1,
					"attack_range": 120,
					"attack_rate": 1.4,
					"pierce": 1,
				},
			},
			3: {
				"upgrade_cost": 200,
				"upgrade_desc": "Arrow pierce +1",
				"stats": {
					"damage": 1,
					"attack_range": 120,
					"attack_rate": 1.4,
					"pierce": 2,
				},
			},
			4: {
				"upgrade_cost": 300,
				"upgrade_desc": "Attack delay -0.7s",
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
				"upgrade_desc": "Attack delay -0.9s",
				"stats": {
					"damage": 2,
					"attack_range": 60,
					"attack_rate": 1.8,
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
				"upgrade_desc": "Attack delay -1.5s",
				"stats": {
					"damage": 1,
					"attack_range": 70,
					"attack_rate": 1.4,
					"zap_count": 5,
				},
			},
		},
	},
}

const wave_award = 100
