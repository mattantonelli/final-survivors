extends Node2D

var peaked = false
var speed = 3.0


func _ready():
	# Shift the position to the center point of the label
	position -= Vector2($RichTextLabel.get_content_width() / 2,
		$RichTextLabel.get_content_height() / 2)

	# Position the label along the float path and display it
	$RichTextLabel.position = $FloatPath/FloatPoint.global_position
	$RichTextLabel.show()


func _process(delta):
	var location = $FloatPath/FloatPoint

	if peaked && location.progress_ratio == 0.0:
		queue_free()

	if peaked:
		location.progress_ratio = maxf(location.progress_ratio - delta * speed, 0.0)
		$RichTextLabel.modulate.a = location.progress_ratio
	else:
		location.progress_ratio = minf(location.progress_ratio + delta * speed, 1.0)
		peaked = location.progress_ratio == 1.0

	$RichTextLabel.position = location.global_position


func set_text(text: String):
	$RichTextLabel.text = text
