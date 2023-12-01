extends AimableItem
class_name AimableTerrorist


static var spotted_terrorists: int = 0
const NUMBER_OF_TERRORISTS: int = 5


func _ready() -> void:
	interactuable = false


func on_scope_click() -> void:
	if interactuable:
		item_name = "SNIPER_TOOLTIP_IDENTIFIED"
		on_scope_in()
		interactuable = false
		spotted_terrorists += 1
		if spotted_terrorists == NUMBER_OF_TERRORISTS:
			Global.get_main().start_phase_found_all_terrorists()
