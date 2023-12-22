extends Area2D

@export var speed = 80
var target : Node2D


func _ready():
	pass


func _physics_process(delta):
	var player = get_node("../Player")
	if (player):
		# Move towards the player
		var velocity = (player.position - position).normalized()
		position += velocity * speed * delta
		
		# Animate facing based on horizontal velocity
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0


func damage():
	queue_free()


func _on_area_entered(area):
	area.hide()
