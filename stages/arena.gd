extends Node

@export var Enemy : PackedScene


func _ready():
	set_camera_limits()
	$Player.show()


func spawn_enemy():
	#if $SpawnTimer.wait_time > 0.2:
		#$SpawnTimer.wait_time -= 0.05

	var enemy = Enemy.instantiate()
	enemy.give_xp.connect(Callable($Player, "give_xp"))

	var spawn_point = $Player/EnemySpawnPath/EnemySpawnPoint
	spawn_point.progress_ratio = randf()
	enemy.position = spawn_point.global_position

	add_child(enemy)


func start_game():
	# Remove old nodes and reset the spawn timer
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("projectiles", "queue_free")
	$SpawnTimer.wait_time = 1.0
	$SpawnTimer.start()

	$Player.respawn()
	$Player.position = $StartPosition.position

	$CanvasLayer/RetryButton.hide()


func set_camera_limits():
	var map_limits = $TileMap.get_used_rect()
	var tile_size = $TileMap.tile_set.tile_size

	$Player/Camera2D.limit_left = map_limits.position.x * tile_size.x
	$Player/Camera2D.limit_right = map_limits.end.x * tile_size.x
	$Player/Camera2D.limit_top = map_limits.position.y * tile_size.y
	$Player/Camera2D.limit_bottom = map_limits.end.y * tile_size.y

	$Player.move_limit = Vector2(map_limits.end.x * tile_size.x,
		map_limits.end.y * tile_size.y)


func _on_player_hp_changed(amount):
	if amount == 0:
		get_node("CanvasLayer/RetryButton").show()
