extends Node

@export var Enemy : PackedScene

func _ready():
	$Player.show()


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


func start_game():
	# Remove old enemies and reset the spawn timer
	get_tree().call_group("enemies", "queue_free")
	$SpawnTimer.wait_time = 1.0
	$SpawnTimer.start()

	$Player.respawn()
	$Player.position = $StartPosition.position

	get_node("CanvasLayer/RetryButton").hide()


func _on_player_hp_changed(amount):
	if amount == 0:
		get_node("CanvasLayer/RetryButton").show()
