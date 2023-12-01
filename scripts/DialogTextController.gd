extends RichTextLabel
class_name DialogTextController


var target_text_name_with_color: String = ""
var target_text_name_without_color: String = ""
var target_text: String = ""
var time_elapsed: float = 0.0
var chars_per_second: float = 80.0
var text_finished: bool = true
@onready var _DialogController: DialogController = get_parent().get_parent()


func _process(delta: float) -> void:
	time_elapsed += delta
	var chars_to_show: int = round(time_elapsed * chars_per_second) + target_text_name_with_color.length()
	var text_to_show := target_text.substr(0, chars_to_show)
	text = text_to_show
	if !text_finished && text == target_text:
		_DialogController._on_dialog_text_finished()
		text_finished = true


func get_string_width(s: String) -> float:
	return get_theme_font("font").get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, get_theme_font_size("font_size")).x


func break_text(s: String) -> String:
	var new_s: String = ""
	var current_line: String = ""
	var max_line_width: float = get_rect().size.x - 430 # I literally don't know why I need a "420" here, but it works

	var words: PackedStringArray = (target_text_name_without_color + s).split(" ")
	for word in words:
		var potential_line := current_line + " " + word
		var line_width := get_string_width(potential_line)

		if line_width > max_line_width:
			new_s += current_line + "\n"
			current_line = ""

		current_line += word + " "
	new_s += current_line
	return target_text_name_with_color + new_s.substr(target_text_name_without_color.length(), new_s.length())


func set_target_text(s: String, name_with_color: String, name_without_color: String) -> void:
	text = name_with_color
	target_text_name_with_color = name_with_color
	target_text_name_without_color = name_without_color
	target_text = break_text(s)
	time_elapsed = 0.0
	text_finished = false


func set_dialog_line(dialog_line: DialogLine) -> void:
	set_target_text(dialog_line.text, dialog_line.get_name(), dialog_line.get_name(false))


func finish_text() -> void:
	time_elapsed = 999999
	text = target_text
	if !text_finished:
		_DialogController._on_dialog_text_finished()
		text_finished = true
