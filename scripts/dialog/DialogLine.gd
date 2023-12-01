class_name DialogLine


# CSV Fields
var next_line_number: int
var type: String
var color: String
var form: String
var text: String
var meta: String

# Metadata
var line_number: int
var all_options: Array[DialogLine] = []


var TextureBoxBaddie: Texture = load("res://sprites/gui/boxes/text_box_baddie.png")
var TextureBoxMain: Texture = load("res://sprites/gui/boxes/text_box_main.png")
var TextureBoxRadio: Texture = load("res://sprites/gui/boxes/text_box_radio.png")


func stringToInteger(s: String) -> int:
	return -1 if s == "" else s.to_int()


func _init(csv_line_number: int, csv_line: PackedStringArray) -> void:
	var locale := TranslationServer.get_locale()
	line_number = csv_line_number
	next_line_number = stringToInteger(csv_line[0])
	type = csv_line[1]
	color = csv_line[2]
	form = csv_line[3]
	meta = csv_line[4]
	text = csv_line[6]

	if next_line_number == -1:
		next_line_number = csv_line_number + 1

	if locale == "en":
		text = csv_line[7]


func is_empty() -> bool:
	return text == ""


func is_option() -> bool:
	return type == "R"


func get_color() -> Color:
	var colors: Dictionary = {
		"1": Color(0.91, 0.58, 0.2),
		"2": Color(0.58, 0.44, 0.6),
		"3": Color(0.1, 0.3, 0.33),
		"4": Color(0.73, 0.17, 0.17),
		"5": Color(1, 1, 1),
		"6": Color(0.73, 0.17, 0.17),
		"": Color(1, 1, 1),
		"0": Color(1, 1, 1),
	}

	return colors[color]

func get_name(with_color: bool = true) -> String:
	var names: Dictionary = {
		"1": tr("DIALOG_NAME_SHERIFF"),
		"2": tr("DIALOG_NAME_SNIPER"),
		"3": tr("DIALOG_NAME_MILLER"),
		"4": tr("DIALOG_NAME_VILLAIN1"),
		"5": tr("DIALOG_NAME_PLAYER"),
		"6": tr("DIALOG_NAME_VILLAIN2"),
	}

	var name_text: String = names[color] + ": "

	if !with_color:
		return name_text
	return "[color=\"#" + get_color().to_html() + "\"] " + name_text + "[/color]"


func get_box_texture() -> Texture:
	if form == "A":
		return TextureBoxMain
	elif form == "B":
		return TextureBoxBaddie
	else:
		return TextureBoxRadio
