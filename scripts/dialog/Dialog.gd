class_name Dialog


var name: String
var graph: Array[DialogLine] = []


# Dictionary<String, Dialog>
# Get element with get_dialog() method
static var dialogs: Dictionary = {}


static func get_dialog(file_name: String) -> Dialog:
	if !dialogs.has(file_name):
		dialogs[file_name] = Dialog.new(file_name)
	return dialogs[file_name]


static func reset() -> void:
	dialogs = {}


func _init(file_name: String) -> void:
	name = file_name
	var file := FileAccess.open("res://dialogs/" + name + ".csv", FileAccess.READ)

	var options_buffer: Array[DialogLine] = []
	var csv_line_number: int = 0
	while !file.eof_reached():
		csv_line_number += 1
		var csv_line: PackedStringArray = file.get_csv_line()

		var dialog_line := DialogLine.new(csv_line_number, csv_line)

		if dialog_line.is_empty():
			continue

		if dialog_line.is_option():
			options_buffer.append(dialog_line)
		else:
			if options_buffer.size() > 0:
				for option in options_buffer:
					option.all_options = options_buffer
				graph.append(options_buffer[0])
				options_buffer = []
			graph.append(dialog_line)
	file.close()


func get_dialog_line(line_number: int) -> DialogLine:
	for i in range(graph.size()):
		var dialog_line := graph[i]
		if dialog_line.line_number == line_number:
			return dialog_line
	return null


func get_first_dialog_line() -> DialogLine:
	var min_line: int = 999999
	var min_dialog_line: DialogLine = null
	for i in range(graph.size()):
		var dialog_line := graph[i]
		if dialog_line.line_number < min_line:
			min_line = dialog_line.line_number
			min_dialog_line = dialog_line
	return min_dialog_line


func get_next_dialog_line(dialog_line: DialogLine) -> DialogLine:
	var next_line_number: int = dialog_line.next_line_number

	if next_line_number == 0:
		return null

	var next_dialog_line: DialogLine = get_dialog_line(next_line_number)
	while !next_dialog_line:
		if next_line_number > 999999:
			assert(false, "No next dialog_line found")
		next_line_number += 1
		next_dialog_line = get_dialog_line(next_line_number)
	return next_dialog_line
