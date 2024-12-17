extends Area2D

var max_health: int = 20
var current_health: int

@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = max_health

func _process(_delta: float) -> void:
	if current_health == max_health:
		health_bar.visible = false
	else:
		health_bar.visible = true

func take_damage(dmg: int) -> void:
	current_health -= dmg
	health_bar.value = current_health
	if current_health <= 0:
		level_over()
		queue_free()

func level_over() -> void:
	# TODO: making setting level_over a setter that emits the signal?
	LevelState.level_over = true
	SignalBus.level_over.emit("loss")
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	for i in range(enemies.size()):
		enemies[i].get_parent().queue_free()
