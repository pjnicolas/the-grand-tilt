extends Node2D
class_name ViewSniperController


var is_mouse_right_pressed := false
@onready var _Camera: SniperCameraController = get_node("Camera2D")
@onready var _MapZoomIn: Node2D = get_node("MapZoomIn")
@onready var _MapZoomOut: Sprite2D = get_node("MapZoomOut")
@onready var _ZoomInObjects: Node2D = get_node("MapZoomIn/ZoomInObjects")
@onready var _Decals: Node2D = get_node("MapZoomIn/Decals")
@onready var _LightsOff: Node2D = get_node("MapZoomIn/LightsOff")
@onready var _Dialog: DialogController = get_node("Dialog")
var after_shoot_fn: Callable

@onready var _MarkerZoomOutStart: Node2D = get_node("Markers/ZoomOutStart")
@onready var _MarkerZoomOutEnd: Node2D = get_node("Markers/ZoomOutEnd")
@onready var _MarkerZoomInStart: Node2D = get_node("Markers/ZoomInStart")
@onready var _MarkerZoomInEnd: Node2D = get_node("Markers/ZoomInEnd")

var PrefabDecal: PackedScene = load("res://prefabs/decal.tscn")

var in_dialog := false
var dead := false
var dialog_on_enter_tree: Dialog = null


func translate_position_out_to_in(out_position: Vector2) -> Vector2:
	var out_position_x: float = out_position.x
	var out_position_y: float = out_position.y
	var out_position_x_normalized: float = (out_position_x - _MarkerZoomOutStart.position.x) / (_MarkerZoomOutEnd.position.x - _MarkerZoomOutStart.position.x)
	var out_position_y_normalized: float = (out_position_y - _MarkerZoomOutStart.position.y) / (_MarkerZoomOutEnd.position.y - _MarkerZoomOutStart.position.y)
	var in_position_x: float = _MarkerZoomInStart.position.x + (_MarkerZoomInEnd.position.x - _MarkerZoomInStart.position.x) * out_position_x_normalized
	var in_position_y: float = _MarkerZoomInStart.position.y + (_MarkerZoomInEnd.position.y - _MarkerZoomInStart.position.y) * out_position_y_normalized
	return Vector2(in_position_x, in_position_y)



func _ready() -> void:
	_MapZoomIn.visible = false
	_MapZoomOut.visible = true


func _enter_tree() -> void:
	if dialog_on_enter_tree:
		in_dialog = true
		on_release_right_button()
		_Dialog.visible = true
		_Dialog.load_dialog(dialog_on_enter_tree)
		dialog_on_enter_tree = null


func _process(_delta: float) -> void:
	if in_dialog || dead:
		return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if !is_mouse_right_pressed:
			Global.hide_roles()
			_Camera.show_scope(translate_position_out_to_in(get_global_mouse_position()))
			_MapZoomIn.visible = true
			_MapZoomOut.visible = false
			is_mouse_right_pressed = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		check_objects_in_scope()
	else:
		on_release_right_button()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && is_mouse_right_pressed:
		var mouse_motion: Vector2 = event.relative
		_Camera.set_camera_position(_Camera.position + mouse_motion * 1.0) # 1.0 = hardcoded value mouse sensitivity


func on_release_right_button() -> void:
	Global.show_roles()
	is_mouse_right_pressed = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_Camera.hide_scope()
	_MapZoomIn.visible = false
	_MapZoomOut.visible = true
	on_after_shoot()


func check_objects_in_scope() -> void:
	_Camera._Hint.visible = false
	_Camera._AimItemName.text = ""
	for object: AimableItem in _ZoomInObjects.get_children():
		if is_scope_aiming_on_object(object):
			_Camera._AimItemName.text = object.item_name
			if object.interactuable:
				_Camera._Hint.visible = true
				_Camera._Hint_Text.text = "SNIPER_TOOLTIP_IDENTIFY"
				if object is AimableShadow || object is AimableDoorLock || object is AimableYourself:
					_Camera._Hint_Text.text = "SNIPER_TOOLTIP_SHOOT"
			object.on_scope_in()
			if Input.is_action_just_pressed("left_click"):
				object.on_scope_click()
		else:
			object.on_scope_out()


func is_scope_aiming_on_object(object: Sprite2D) -> bool:
	return object.visible && _Camera.position.x > object.position.x - object.get_rect().size.x * object.scale.x / 2.0 \
		&& _Camera.position.x < object.position.x + object.get_rect().size.x * object.scale.x / 2.0 \
		&& _Camera.position.y > object.position.y - object.get_rect().size.y * object.scale.y / 2.0 \
		&& _Camera.position.y < object.position.y + object.get_rect().size.y * object.scale.y / 2.0


func start_phase_found_hostage() -> void:
	in_dialog = true
	on_release_right_button()
	_Dialog.visible = true
	_Dialog.connect_on_dialog_end(Callable(self, "on_dialog_end"))
	_Dialog.load_dialog(Dialog.get_dialog("3"))


func on_dialog_end(file_name: String, _line_number: int) -> void:
	in_dialog = false
	if file_name == "3":
		Global.get_main().start_phase_found_hurt_hostage()
	elif file_name == "5":
		Global.get_main().start_phase_found_all_terrorists_2()
	elif file_name == "9":
		Global.get_main().start_phase_ducts_door_open()


func shoot(_at_position: Vector2, light: int = 0) -> void:
	var decal: Sprite2D = PrefabDecal.instantiate()
	_Decals.add_child(decal)
	decal.position = _Camera.position
	_Camera.shoot()

	# Oh Lord, sorry for this code...
	if light > 0:
		var black: ColorRect = _LightsOff.get_node("Black" + str(light))
		black.visible = true


func shoot_fast() -> void:
	_Camera.shoot_fast()


func on_after_shoot() -> void:
	if after_shoot_fn:
		var tmp_callable := after_shoot_fn
		after_shoot_fn = Callable()
		tmp_callable.call()
