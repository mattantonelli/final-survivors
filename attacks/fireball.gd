extends Area2D

@export var atk = 1
@export var speed = 400

var velocity : Vector2 # Firing direction


func _physics_process(delta):
	position += velocity * speed * delta

	# Damage the first enemy hit and delete this node
	var enemies = get_overlapping_areas()
	if enemies.size() > 0:
		enemies[0].damage(atk)
		queue_free()


# Delete the node when it exits the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	area.damage(atk)
	queue_free()
