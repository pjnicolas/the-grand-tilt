extends Node


var ducts_door_found := false
var ducts_door_open := false
var roles_enabled := true
var corrupt := false
var _AudioStreamPlayer: AudioStreamPlayer = null

var DEBUG := false

var MusicVice1: AudioStreamMP3 = load("res://audio/music/vice1.mp3")
var MusicVice2: AudioStreamMP3 = load("res://audio/music/vice2.mp3")
var MusicDivided1: AudioStreamMP3 = load("res://audio/music/divided_we_fall1.mp3")
var MusicDivided2: AudioStreamMP3 = load("res://audio/music/divided_we_fall2.mp3")
var MusicRunning1: AudioStreamMP3 = load("res://audio/music/running_from_death1.mp3")
var MusicRunning2: AudioStreamMP3 = load("res://audio/music/running_from_death2.mp3")
var MusicCops1: AudioStreamMP3 = load("res://audio/music/super_cops1.mp3")
var MusicCops2: AudioStreamMP3 = load("res://audio/music/super_cops2.mp3")


var TextureMouseArray: Texture = load("res://sprites/gui/cursor/cursor_arrow.png")
var TextureMouseCrosshair: Texture = load("res://sprites/gui/cursor/cursor_cosshair.png")
var TextureMouseFinger: Texture = load("res://sprites/gui/cursor/cursor_finger.png")


func _ready() -> void:
	_AudioStreamPlayer = AudioStreamPlayer.new()
	_AudioStreamPlayer.volume_db = -20
	add_child(_AudioStreamPlayer)
	play(MusicVice1)
	_AudioStreamPlayer.connect("finished", on_music_finished)
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	Input.set_custom_mouse_cursor(TextureMouseArray, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(TextureMouseCrosshair, Input.CURSOR_CROSS)
	Input.set_custom_mouse_cursor(TextureMouseFinger, Input.CURSOR_POINTING_HAND)


func play(song: AudioStreamMP3) -> void:
	if _AudioStreamPlayer:
		_AudioStreamPlayer.stop()
		_AudioStreamPlayer.stream = song
		_AudioStreamPlayer.play()


func stop() -> void:
	_AudioStreamPlayer.stop()


func on_music_finished() -> void:
	if _AudioStreamPlayer.stream == MusicVice1:
		_AudioStreamPlayer.stream = MusicVice2
	elif _AudioStreamPlayer.stream == MusicVice2:
		_AudioStreamPlayer.stream = MusicVice2
	elif _AudioStreamPlayer.stream == MusicDivided1:
		_AudioStreamPlayer.stream = MusicDivided2
	elif _AudioStreamPlayer.stream == MusicDivided2:
		_AudioStreamPlayer.stream = MusicDivided2
	elif _AudioStreamPlayer.stream == MusicRunning1:
		_AudioStreamPlayer.stream = MusicRunning2
	elif _AudioStreamPlayer.stream == MusicRunning2:
		_AudioStreamPlayer.stream = MusicRunning2
	elif _AudioStreamPlayer.stream == MusicCops1:
		_AudioStreamPlayer.stream = MusicCops2
	elif _AudioStreamPlayer.stream == MusicCops2:
		_AudioStreamPlayer.stream = MusicCops2
	_AudioStreamPlayer.play()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func get_main() -> MainController:
	return get_tree().get_root().get_node("Main") as MainController


func get_roles() -> RolesController:
	return get_main().get_node("Roles") as RolesController


func hide_roles() -> void:
	get_roles().visible = false


func show_roles() -> void:
	get_roles().visible = true


func disable_roles() -> void:
	roles_enabled = false
	get_roles().disable()


func enable_roles() -> void:
	roles_enabled = true
	get_roles().enable()
