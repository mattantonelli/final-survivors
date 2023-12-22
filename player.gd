extends Area2D

@export var Attack : PackedScene
@export var max_hp = 10
@export var speed = 300

var hp: int
var screen_size

signal hp_changed(amount: int)


func _ready():
	screen_size = get_viewport_rect().size
	set_hp(max_hp)


func _process(delta):
	# Disable actions if the player is dead
	if hp == 0: return

	process_movement(delta)

	if Input.is_action_just_pressed("attack"):
		process_attack()


func _physics_process(_delta):
	process_collisions()


func process_attack():
	var click = get_viewport().get_mouse_position()
	var projectile = Attack.instantiate()

	# Spawn the projectile at the player's position
	var velocity = (click - position).normalized()
	projectile.position = position

	# Rotate and fire towards the cursor location
	projectile.velocity = (click - position).normalized()
	projectile.rotation = projectile.velocity.angle()

	get_parent().add_child(projectile)


func process_movement(delta):
	var velocity = Vector2.ZERO

	# Handle movement input
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	velocity = velocity.normalized() * speed

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# Animate facing based on horizontal velocity
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x > 0


func process_collisions():
	if has_overlapping_areas():
		# If an enemy is overlapping the player, take damage
		# TODO: Maybe take the maximum hit here instead of the "first"
		var enemy = get_overlapping_areas()[0]
		damage(enemy.atk)

		# Set a red color mask to indicate damage
		modulate = Color(1, 0, 0, 1)
	elif $InvulnerabilityTimer.is_stopped():
		# Reset the color mask when the player stops taking damage
		modulate = Color(1, 1, 1, 1)


func damage(value: int):
	# If the player is vulnerable
	if $InvulnerabilityTimer.is_stopped():
		# Reduce the player's health to a minimum of 0 based on the damage
		set_hp(maxi(hp - value, 0))

		if (hp == 0):
			# If HP reaches 0, hide the Player and disable collision
			hide()
			$CollisionShape2D.set_deferred("disabled", true)
		else:
			# Otherwise, start the invulnerability window
			$InvulnerabilityTimer.start()


func respawn():
	set_hp(max_hp)
	$CollisionShape2D.set_deferred("disabled", false)
	show()


func set_hp(value: int):
	hp = value
	$HealthBar.update(value, max_hp)
	hp_changed.emit(value)
