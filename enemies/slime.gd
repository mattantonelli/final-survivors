extends Area2D

@export var atk = 1
@export var max_hp = 1
@export var speed = 80

var hp: int
var opacity = 1.0
var target : Node2D


func _ready():
	hp = max_hp
	target = get_parent().get_node("Player")


func _process(delta):
	if opacity <= 0:
		# Delete the node after it has completely faded
		queue_free()
	if hp == 0:
		# Fade to death once HP reaches 0
		opacity -= delta * 12
		modulate = Color(1, 1, 1, opacity)

func _physics_process(delta):
	# If the enemy has a target (player) and has not already reached them
	if hp > 0 && target && target.visible && !has_overlapping_areas():
		# Move towards the target
		var velocity = (target.position - position).normalized()
		position += velocity * speed * delta

		# Animate facing based on horizontal velocity
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0


func damage(value):
	hp = maxi(hp - value, 0)

	if hp == 0:
		$CollisionShape2D.set_deferred("disabled", true)
