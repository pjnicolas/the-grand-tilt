extends AimableItem
class_name PersonaHerida

func _ready() -> void:
	interactuable = true


func on_scope_click() -> void:
	if interactuable:
		on_scope_out()
		interactuable = false
		_ViewSniper.start_phase_found_hostage()
