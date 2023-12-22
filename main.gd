extends Node

@export var Enemy : PackedScene

func _ready():
	pass


func _process(_delta):
	pass


func spawn_enemy():
	if $SpawnTimer.wait_time > 0.2:
		$SpawnTimer.wait_time -= 0.05
	
	var enemy = Enemy.instantiate()
	var spawn_point = get_node("EnemySpawnPath/EnemySpawnPoint")
	
	spawn_point.progress_ratio = randf()
	enemy.position = spawn_point.position
	
	add_child(enemy)
