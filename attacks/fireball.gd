extends Area2D

@export var speed = 400
var velocity : Vector2 # Firing direction


func _ready():
	pass


func _physics_process(delta):
	position += velocity * speed * delta


# Delete the node when it exits the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	area.damage()
	queue_free()
