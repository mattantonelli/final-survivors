extends Area2D

@export var speed = 300
@export var Attack : PackedScene
var screen_size


func _ready():
	screen_size = get_viewport_rect().size


func _process(delta):
	process_movement(delta)
	
	if Input.is_action_just_pressed("attack"):
		process_attack()


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
