extends Node

enum EnemyType {
	GREEN_SLIME,
	BLUE_SLIME,
	TANK_SLIME,
	ICE_SLIME,
	SLIME_BOSS_ONE,
	SLIME_BOSS_TWO,
}

enum TowerType {
	NONE,
	ARCHER,
	FIREBALL,
	ZAP,
	BEAM,
}

enum Upgrade {
	START_GOLD,
	WAVE_CLEAR_AWARD,
}

var upgrade_data: Dictionary = {
	Upgrade.START_GOLD: {
		"label": "Start Gold",
		"lvl_data": {
			1: {
				"upgrade_cost": 0,
				"value": 250,
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
				"value": 800,
			},
			5: {
				"upgrade_cost": 60,
				"value": 1000,
			},
			6: {
				"upgrade_cost": 90,
				"value": 1200,
			},
			7: {
				"upgrade_cost": 120,
				"value": 1500,
			},
			8: {
				"upgrade_cost": 160,
				"value": 1800,
			},
			9: {
				"upgrade_cost": 200,
				"value": 2100,
			},
			10: {
				"upgrade_cost": 250,
				"value": 2400,
			},
		}
	},
	Upgrade.WAVE_CLEAR_AWARD: {
		"label": "Wave Clear Award",
		"lvl_data": {
			1: {
				"upgrade_cost": 10,
				"value": 100,
			},
			2: {
				"upgrade_cost": 20,
				"value": 120,
			},
			3: {
				"upgrade_cost": 40,
				"value": 150,
			},
			4: {
				"upgrade_cost": 60,
				"value": 180,
			},
			5: {
				"upgrade_cost": 100,
				"value": 220,
			},
		}
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
				"wait_time": 0.2
			},
			{
				"enemy_type": EnemyType.GREEN_SLIME,
				"count": 20,
				"wait_time": 0.2
			},
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 50,
				"wait_time": 0.2
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
		11: [
			{
				"enemy_type": EnemyType.SLIME_BOSS_ONE,
				"count": 1,
				"wait_time": 1.0
			}
		]
	},
	2: {
		1: [
			# Phase
			{
				"enemy_type": EnemyType.ICE_SLIME,
				"count": 5,
				"wait_time": 1.0
			},
		],
		#1: [
			## Phase
			#{
				#"enemy_type": EnemyType.BLUE_SLIME,
				#"count": 1,
				#"wait_time": 0.6
			#},
		#],
		2: [
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 10,
				"wait_time": 0.6
			},
		],
		3: [
			{
				"enemy_type": EnemyType.BLUE_SLIME,
				"count": 15,
				"wait_time": 0.6
			},
		],
	}
}

## Enemy Data
var e_data: Dictionary = {
	EnemyType.GREEN_SLIME: {
		"hp": 1,
		"speed": 40,
		"tower_damage": 1,
		"label": "Green Slime",
		"gold_award": 5,
		"rp_award": 1,
	},
	EnemyType.BLUE_SLIME: {
		"hp": 3,
		"speed": 50,
		"tower_damage": 2,
		"label": "Blue Slime",
		"gold_award": 10,
		"rp_award": 2,
	},
	EnemyType.TANK_SLIME: {
		"hp": 15,
		"speed": 35,
		"tower_damage": 3,
		"label": "Tank Slime",
		"gold_award": 15,
		"rp_award": 3,
	},
	EnemyType.ICE_SLIME: {
		"hp": 5,
		"speed": 40,
		"tower_damage": 5,
		"label": "Ice Slime",
		"gold_award": 20,
		"rp_award": 5,
	},
	EnemyType.SLIME_BOSS_ONE: {
		"hp": 500,
		"speed": 20,
		"tower_damage": 100000,
		"label": "Gelatinous Terror",
		"gold_award": 500,
		"rp_award": 200,
	},
	EnemyType.SLIME_BOSS_TWO: {
		"hp": 2000,
		"speed": 30,
		"tower_damage": 100000,
		"label": "Frozen Monstrosity",
		"gold_award": 2000,
		"rp_award": 1000,
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
					"atk_range": 90,
					"atk_cooldown": 1.4,
					"pierce": 1,
				},
			},
			2: {
				"upgrade_cost": 100,
				"upgrade_desc": "Attack range +33%",
				"stats": {
					"damage": 1,
					"atk_range": 120,
					"atk_cooldown": 1.4,
					"pierce": 1,
				},
			},
			3: {
				"upgrade_cost": 250,
				"upgrade_desc": "Arrow pierce +1",
				"stats": {
					"damage": 1,
					"atk_range": 120,
					"atk_cooldown": 1.4,
					"pierce": 2,
				},
			},
			4: {
				"upgrade_cost": 400,
				"upgrade_desc": "Attack delay -50%",
				"stats": {
					"damage": 1,
					"atk_range": 120,
					"atk_cooldown": 0.7,
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
					"atk_range": 60,
					"atk_cooldown": 2.7,
				},
			},
			2: {
				"upgrade_cost": 450,
				"upgrade_desc": "Damage +1",
				"stats": {
					"damage": 2,
					"atk_range": 60,
					"atk_cooldown": 2.7,
				},
			},
			3: {
				"upgrade_cost": 700,
				"upgrade_desc": "Attack delay -40%",
				"stats": {
					"damage": 2,
					"atk_range": 60,
					"atk_cooldown": 1.6,
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
					"atk_range": 70,
					"atk_cooldown": 3.6,
					"zap_count": 3,
				},
			},
			2: {
				"upgrade_cost": 250,
				"upgrade_desc": "+2 zap chain",
				"stats": {
					"damage": 1,
					"atk_range": 70,
					"atk_cooldown": 3.6,
					"zap_count": 5,
				},
			},
			3: {
				"upgrade_cost": 450,
				"upgrade_desc": "Attack delay -40%",
				"stats": {
					"damage": 1,
					"atk_range": 70,
					"atk_cooldown": 2.2,
					"zap_count": 5,
				},
			},
		},
	},
	TowerType.BEAM: {
		"cost": 900,
		"label": "Beam Tower",
		"lvl_data": {
			1: {
				"upgrade_cost": 0,
				"upgrade_desc": "Base stats",
				"stats": {
					"damage": 1,
					"atk_range": 80,
					"atk_cooldown": 0.4,
				},
			},
			2: {
				"upgrade_cost": 650,
				"upgrade_desc": "Attack delay -50%",
				"stats": {
					"damage": 1,
					"atk_range": 80,
					"atk_cooldown": 0.2,
				},
			},
			3: {
				"upgrade_cost": 1100,
				"upgrade_desc": "Damage +2",
				"stats": {
					"damage": 3,
					"atk_range": 80,
					"atk_cooldown": 0.2,
				},
			},
		},
	},
}

#const wave_award = 100
