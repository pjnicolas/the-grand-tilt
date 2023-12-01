extends CanvasLayer
class_name RolesController


enum Role { Sheriff, Sniper, Ducts }

var RoleButtonPrefab: PackedScene = preload("res://prefabs/role_button.tscn")


var RoleSheriffTexture: Texture = load("res://sprites/screens/main/main.png")
var RoleSniperTexture: Texture = load("res://sprites/screens/sniper/sniper.png")
var RoleDuctsTexture: Texture = load("res://sprites/screens/vents/role_thumbnail.png")


var _Sheriff: RoleButtonController
var _Sniper: RoleButtonController
var _Ducts: RoleButtonController


var center: Vector2 = Vector2(871, 43)
var pos1: Vector2 = center
var pos2: Vector2 = pos1 + Vector2(0, 160)
var pos3: Vector2 = pos2 + Vector2(0, 160)
@onready var show_sniper: bool = Global.DEBUG
@onready var show_ducts: bool = Global.DEBUG
var current_role: Role = Role.Sheriff


func _ready() -> void:
	_Sheriff = RoleButtonPrefab.instantiate()
	_Sniper = RoleButtonPrefab.instantiate()
	_Ducts = RoleButtonPrefab.instantiate()
	add_child(_Sheriff)
	add_child(_Sniper)
	add_child(_Ducts)
	_Sheriff._Sprite2D.texture = RoleSheriffTexture
	_Sniper._Sprite2D.texture = RoleSniperTexture
	_Ducts._Sprite2D.texture = RoleDuctsTexture
	_Sheriff.role = Role.Sheriff
	_Sniper.role = Role.Sniper
	_Ducts.role = Role.Ducts
	_Sheriff.visible = false
	_Sniper.visible = false
	_Ducts.visible = false


func reload_scene() -> void:
	change_scene(current_role)


func change_scene(role: Role) -> void:
	current_role = role
	_Sheriff.visible = true
	_Sniper.visible = true
	_Ducts.visible = true
	if role == Role.Sheriff:
		_Sheriff.visible = false
		_Sniper.position = pos1
		_Ducts.position = pos2
	elif role == Role.Sniper:
		_Sniper.visible = false
		_Sheriff.position = pos1
		_Ducts.position = pos2
	elif role == Role.Ducts:
		_Ducts.visible = false
		_Sheriff.position = pos1
		_Sniper.position = pos2

	if !show_sniper:
		_Sniper.visible = false

	if !show_ducts:
		_Ducts.visible = false

	Global.get_main().change_scene(role)


func disable() -> void:
	_Sheriff.set_disabled(true)
	_Sniper.set_disabled(true)
	_Ducts.set_disabled(true)


func enable() -> void:
	_Sheriff.set_disabled(false)
	_Sniper.set_disabled(false)
	_Ducts.set_disabled(false)
