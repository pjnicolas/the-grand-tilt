extends Node2D
class_name ViewSheriffController


@onready var _Dialog: DialogController = get_node("Dialog")
@onready var _Walkie: WalkieController = get_node("Walkie")
@onready var _GlitchPlus: ColorRect = get_node("GlitchPlus")
@onready var _GlitchPlus_AnimationPlayer: AnimationPlayer = get_node("GlitchPlus/AnimationPlayer")
@onready var _EndButtonExport: EndButtonController = get_node("EndButtonExport")
@onready var _EndButtonLoad: EndButtonController = get_node("EndButtonLoad")
@onready var _EndButtonExport_Animation: AnimationPlayer = get_node("EndButtonExport/AnimationPlayer")
@onready var _EndButtonLoad_Animation: AnimationPlayer = get_node("EndButtonLoad/AnimationPlayer")
@onready var _Walkie_AnimationPlayer: AnimationPlayer = get_node("Walkie/AnimationPlayer")

var PrefabGlitch: PackedScene = load("res://prefabs/glitch.tscn")

var dialog_on_enter_tree: Dialog = null


func _enter_tree() -> void:
	if dialog_on_enter_tree:
		_Dialog.visible = true
		_Dialog.load_dialog(dialog_on_enter_tree)
		if dialog_on_enter_tree.name == "14":
			Global.play(Global.MusicRunning1)
		dialog_on_enter_tree = null


func on_dialog_line(_file_name: String, _line_number: int, meta: String) -> void:
	if meta == "WALKIE":
		_Walkie_AnimationPlayer.play("raise")
	if meta == "WALKIE2":
		_Walkie_AnimationPlayer.play("unraise")
	if meta == "MUSICA":
		Global.play(Global.MusicCops1)
	if meta == "MUTE":
		Global.stop()
	if meta == "GLITCH":
		add_child(BackBufferCopy.new())
		add_child(PrefabGlitch.instantiate())
	if meta == "GLITCH+":
		_GlitchPlus.visible = true
		_GlitchPlus_AnimationPlayer.play("glitch")
		_EndButtonExport.mouse_filter = Control.MOUSE_FILTER_STOP
		_EndButtonLoad.mouse_filter = Control.MOUSE_FILTER_STOP
	if meta == "BOT_INTE":
		_EndButtonExport.visible = true
		_EndButtonExport_Animation.play("rise")
	if meta == "BOT_BORR":
		_EndButtonLoad.visible = true
		_EndButtonLoad_Animation.play("rise")
	if meta == "HANG":
		_Walkie.hang()
		_Dialog._AudioStreamPlayer.play()
		_Dialog.using_walkie = false


func on_dialog_end(file_name: String, _line_number: int) -> void:
	if file_name == "1":
		_Walkie.next_dialog = Dialog.get_dialog("2")
	if file_name == "2":
		var _Roles: RolesController = get_tree().get_root().get_node("Main/Roles")
		_Roles.show_sniper = true
		_Roles.reload_scene()
	elif file_name == "4":
		Global.get_main().start_phase_seek_terrorists()
	elif file_name == "6":
		Global.get_main().start_phase_ducts()
	elif file_name == "10":
		Global.get_main().start_phase_enable_basement()
	# elif file_name == "11":
	# 	Global.get_main().start_phase_ducts_dead_2()
	elif file_name == "12":
		Global.get_main().start_phase_sniper_angry()
	_Walkie.unhang()


func start_phase_init() -> void:
	_Dialog.connect_on_dialog_line(Callable(self, "on_dialog_line"))
	_Dialog.connect_on_dialog_end(Callable(self, "on_dialog_end"))
	_Dialog.load_dialog(Dialog.get_dialog("1"))
