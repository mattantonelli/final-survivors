extends AnimatedSprite2D


func update(hp, max_hp):
	# Set the frame based on the % of health (e.g. 90% = frame 9)
	frame = int((hp / float(max_hp)) * 10)
