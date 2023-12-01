extends Node2D
class_name MainController

var ViewSheriffScene: PackedScene = load("res://scenes/view_sheriff.tscn")
var ViewSniperScene: PackedScene = load("res://scenes/view_sniper.tscn")
var ViewDuctsScene: PackedScene = load("res://scenes/view_ducts.tscn")

var _ViewSheriff: ViewSheriffController
var _ViewSniper: ViewSniperController
var _ViewDucts: ViewDuctsController

var PrefabWhiteNoise: PackedScene = load("res://prefabs/white_noise.tscn")


func _ready() -> void:
	_ViewSheriff = ViewSheriffScene.instantiate()
	_ViewSniper = ViewSniperScene.instantiate()
	_ViewDucts = ViewDuctsScene.instantiate()
	change_scene(RolesController.Role.Sheriff)
	_ViewSheriff.start_phase_init()


func change_scene(role: RolesController.Role) -> void:
	remove_child(_ViewSheriff)
	remove_child(_ViewSniper)
	remove_child(_ViewDucts)
	if role == RolesController.Role.Sheriff:
		add_child(_ViewSheriff)
	elif role == RolesController.Role.Sniper:
		add_child(_ViewSniper)
	elif role == RolesController.Role.Ducts:
		add_child(_ViewDucts)
	else:
		assert(false, "Invalid role")


func start_phase_found_hurt_hostage() -> void:
	_ViewSheriff._Walkie.next_dialog = Dialog.get_dialog("4")


func start_phase_seek_terrorists() -> void:
	var t1: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist1")
	var t2: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist2")
	var t3: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist3")
	var t4: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist4")
	var t5: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist5")

	t1.interactuable = true
	t2.interactuable = true
	t3.interactuable = true
	t4.interactuable = true
	t5.interactuable = true


func start_phase_found_all_terrorists() -> void:
	_ViewSniper.in_dialog = true
	_ViewSniper.on_release_right_button()
	_ViewSniper._Dialog.visible = true
	_ViewSniper._Dialog.load_dialog(Dialog.get_dialog("5"))

	var t1: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist1")
	var t2: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist2")
	var t3: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist3")
	var t4: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist4")
	var t5: AimableTerrorist = _ViewSniper._ZoomInObjects.get_node("Terrorist5")
	t1.set_material(null)
	t2.set_material(null)
	t3.set_material(null)
	t4.set_material(null)
	t5.set_material(null)


func start_phase_found_all_terrorists_2() -> void:
	_ViewSheriff._Walkie.next_dialog = Dialog.get_dialog("6")


func start_phase_ducts() -> void:
	Global.get_roles().show_ducts = true
	Global.get_roles().reload_scene()
	# _ViewDucts.dialog_on_enter_tree = Dialog.get_dialog("7")


func start_phase_ducts_found_door() -> void:
	_ViewDucts._Dialog.visible = true
	_ViewDucts._Dialog.load_dialog(Dialog.get_dialog("8"))


func start_phase_seek_open_door() -> void:
	var d1: AimableDoorLock = _ViewSniper._ZoomInObjects.get_node("DoorLock1")
	var d2: AimableDoorLock = _ViewSniper._ZoomInObjects.get_node("DoorLock2")
	var d3: AimableDoorLock = _ViewSniper._ZoomInObjects.get_node("DoorLock3")
	d1.interactuable = true
	d2.interactuable = true
	d3.interactuable = true


func start_phase_destroyed_door_lock() -> void:
	_ViewSniper.in_dialog = true
	_ViewSniper.on_release_right_button()
	_ViewSniper._Dialog.visible = true
	_ViewSniper._Dialog.load_dialog(Dialog.get_dialog("9"))


func start_phase_ducts_door_open() -> void:
	var d1: AimableDoorLock = _ViewSniper._ZoomInObjects.get_node("DoorLock1")
	var d2: AimableDoorLock = _ViewSniper._ZoomInObjects.get_node("DoorLock2")
	var d3: AimableDoorLock = _ViewSniper._ZoomInObjects.get_node("DoorLock3")
	d1.interactuable = false
	d2.interactuable = false
	d3.interactuable = false
	d1.set_material(null)
	d2.set_material(null)
	d3.set_material(null)
	_ViewDucts.open_door()


func start_phase_saw_last_vent() -> void:
	_ViewSheriff._Walkie.next_dialog = Dialog.get_dialog("10")


func start_phase_enable_basement() -> void:
	_ViewDucts.can_go_basement = true


# func start_phase_ducts_dead() -> void:
# 	Global.get_roles()._Ducts.set_dead(true)
# 	_ViewSheriff.dialog_on_enter_tree = Dialog.get_dialog("11")


func start_phase_ducts_dead_2() -> void:
	_ViewSheriff._Walkie.next_dialog = Dialog.get_dialog("12")


func start_phase_sniper_angry() -> void:
	_ViewSniper.dialog_on_enter_tree = Dialog.get_dialog("13")

	for node in _ViewSniper._ZoomInObjects.get_children() as Array[AimableItem]:
		node.visible = false
		node.interactuable = false

	var s1: AimableShadow = _ViewSniper._ZoomInObjects.get_node("Shadow1")
	s1.visible = true
	s1.interactuable = true

func start_phase_sniper_angry_2() -> void:
	_ViewSniper.in_dialog = true
	_ViewSniper.on_release_right_button()
	_ViewSniper._Dialog.visible = true
	_ViewSniper._Dialog.load_dialog(Dialog.get_dialog("13.1"))

	var s2: AimableShadow = _ViewSniper._ZoomInObjects.get_node("Shadow2")
	var s3: AimableShadow = _ViewSniper._ZoomInObjects.get_node("Shadow3")
	var s4: AimableShadow = _ViewSniper._ZoomInObjects.get_node("Shadow4")
	var s5: AimableShadow = _ViewSniper._ZoomInObjects.get_node("Shadow5")
	var s6: AimableShadow = _ViewSniper._ZoomInObjects.get_node("Shadow6")
	var s7: AimableShadow = _ViewSniper._ZoomInObjects.get_node("Shadow7")
	s2.visible = true
	s3.visible = true
	s4.visible = true
	s5.visible = true
	s6.visible = true
	s7.visible = true
	s2.interactuable = true
	s3.interactuable = true
	s4.interactuable = true
	s5.interactuable = true
	s6.interactuable = true
	s7.interactuable = true


func start_phase_sniper_angry_3() -> void:
	_ViewSniper.in_dialog = true
	_ViewSniper.on_release_right_button()
	_ViewSniper._Dialog.visible = true
	_ViewSniper._Dialog.load_dialog(Dialog.get_dialog("13.2"))

	var y: AimableYourself = _ViewSniper._ZoomInObjects.get_node("Yourself")
	y.visible = true
	y.interactuable = true

	var y2: Sprite2D = _ViewSniper._MapZoomOut.get_node("Yourself")
	y2.visible = true


func start_phase_sniper_dead() -> void:
	Global.get_roles()._Sniper.set_dead(true)
	_ViewSniper.on_release_right_button()
	_ViewSniper._MapZoomIn.visible = false
	_ViewSniper._MapZoomOut.visible = false
	_ViewSniper._ZoomInObjects.visible = false
	_ViewSniper.dead = true
	_ViewSniper.add_child(PrefabWhiteNoise.instantiate())
	_ViewSheriff.dialog_on_enter_tree = Dialog.get_dialog("14")


func start_phase_endgame() -> void:
	pass
