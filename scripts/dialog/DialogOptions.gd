class_name DialogOptions

var line_number: int
var options: Array[DialogLine]


func _init(_line_number: int, _options: Array[DialogLine]) -> void:
    line_number = _line_number
    options = _options
