extends AimableItem
class_name AimableShadow


static var killed_shadows: int = 0
static var shadows_count: int = 0



func _ready() -> void:
	shadows_count += 1
	interactuable = false
	item_name = "r*?@!0$401"


func on_scope_click() -> void:
	if interactuable:
		interactuable = false
		visible = false
		killed_shadows += 1
		_ViewSniper.shoot(position)
		if killed_shadows == 1:
			_ViewSniper.after_shoot_fn = Callable(Global.get_main(), "start_phase_sniper_angry_2")
		if killed_shadows == shadows_count:
			_ViewSniper.after_shoot_fn = Callable(Global.get_main(), "start_phase_sniper_angry_3")
