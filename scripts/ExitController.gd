extends Button


@onready var _Text: RichTextLabel = $Text
@onready var _AudioHover: AudioStreamPlayer = $AudioHover

func _ready() -> void:
	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)
	connect("pressed", on_pressed)
	if OS.get_name() == "Web":
		visible = false


func on_pressed() -> void:
	get_tree().quit()


func on_mouse_entered() -> void:
	_AudioHover.play()
	_Text.modulate = Color(0.98, 0.48, 0, 1)


func on_mouse_exited() -> void:
	_Text.modulate = Color(1, 1, 1, 1)
