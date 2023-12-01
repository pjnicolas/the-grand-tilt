extends RichTextLabel

@export var key: String
@export var centered: bool = true

func _ready() -> void:
	var next_text := ""
	if centered:
		next_text += "[center]"
	next_text += tr(key)
	text = next_text
