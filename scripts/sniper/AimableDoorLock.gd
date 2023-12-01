extends AimableItem
class_name AimableDoorLock


@export var the_real_one: bool = false
@export var light: int = 1


func _ready() -> void:
	interactuable = false


func on_scope_click() -> void:
	if interactuable:
		item_name = ""
		on_scope_in()
		interactuable = false
		_ViewSniper.shoot(position, light)
		interactuable = false
		if the_real_one:
			_ViewSniper.after_shoot_fn = Callable(Global.get_main(), "start_phase_destroyed_door_lock")
		else:
			visible = false
