extends Area2D

@export var atk = 1
@export var xp = 1
@export var max_hp = 2
@export var speed = 80

var hit = false
var hp: int
var opacity = 1.0
var target : Node2D

signal give_xp(amount : int)

const FloatingText = preload("res://floating_text.tscn")


func _ready():
	hp = max_hp
	target = get_parent().get_node("Player")


func _process(delta):
	if opacity <= 0 && !has_node("FloatingText"):
		give_xp.emit(xp)
		queue_free()
	if hp == 0:
		# Fade to death once HP reaches 0
		opacity -= delta * 5
		modulate.a = opacity


func _physics_process(delta):
	# If the enemy has a target (player) and has not already reached them
	if hp > 0 && target && target.visible && !has_overlapping_areas():
		# Move towards the target
		var velocity = (target.position - position).normalized()
		position += velocity * speed * delta

		# Animate facing based on horizontal velocity
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x > 0


func damage(value):
	# Reduce HP to a minimum of 0
	hp = maxi(hp - value, 0)

	# Display the damage number
	var damage_number = FloatingText.instantiate()
	damage_number.set_text(str(value))
	add_child(damage_number)

	# Flash white
	modulate = Color(100, 100, 100, opacity)
	$HitFlashTimer.start()

	if hp == 0:
		$CollisionShape2D.set_deferred("disabled", true)


func _on_hit_flash_timer_timeout():
	modulate = Color(1, 1, 1, opacity)
