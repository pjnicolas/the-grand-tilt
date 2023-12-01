extends AimableItem
class_name AimableYourself


func _ready() -> void:
	interactuable = true
	visible = false


func on_scope_click() -> void:
	_ViewSniper.shoot_fast()
	_ViewSniper.after_shoot_fn = Callable(Global.get_main(), "start_phase_sniper_dead")
	# Global.get_main().start_phase_sniper_dead()
