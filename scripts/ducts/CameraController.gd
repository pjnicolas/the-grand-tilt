extends Camera2D
class_name DuctsCameraController

const SHAKE_POWER: float = 30


var shake := false


func _process(_delta: float) -> void:
	if shake:
		offset.x = randf_range(-SHAKE_POWER, SHAKE_POWER)
		offset.y = randf_range(-SHAKE_POWER, SHAKE_POWER)
	else:
		offset.x = 0
		offset.y = 0
