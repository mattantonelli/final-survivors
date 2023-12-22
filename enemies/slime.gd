extends Area2D

@export var speed = 80
@export var atk = 1
var target : Node2D


func _ready():
	target = get_parent().get_node("Player")


func _physics_process(delta):
	if (target):
		# Move towards the target (player)
		var velocity = (target.position - position).normalized()
		position += velocity * speed * delta

		# Animate facing based on horizontal velocity
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0


func damage():
	queue_free()
