extends Button
class_name LanguageButtonController

enum Languages { ENGLISH, SPANISH }

@export var play_language: Languages
@onready var _Text: RichTextLabel = $Text
@onready var _AudioClick: AudioStreamPlayer = $AudioClick
@onready var _AudioHover: AudioStreamPlayer = $AudioHover


static var instance_en: LanguageButtonController = null
static var instance_es: LanguageButtonController = null


@onready var _Text_Play: RichTextLabel = get_parent().get_node("Play/Text")
@onready var _Text_English: RichTextLabel = get_parent().get_node("PlayEnglish/Text")
@onready var _Text_Spanish: RichTextLabel = get_parent().get_node("PlaySpanish/Text")
@onready var _Text_Fullscreen: RichTextLabel = get_parent().get_node("Fullscreen/Text")
@onready var _Text_Credits: RichTextLabel = get_parent().get_node("Credits/Text")
@onready var _Text_Exit: RichTextLabel = get_parent().get_node("Exit/Text")


var active := false
const ACTIVE_COLOR := Color(0, 0.5, 1, 1)


func _ready() -> void:
	_Text_Play.text = "[center]" + tr("MENU_OPTION_PLAY")
	_Text_English.text = "[center]" + tr("MENU_OPTION_ENGLISH")
	_Text_Spanish.text = "[center]" + tr("MENU_OPTION_SPANISH")
	_Text_Fullscreen.text = "[center]" + tr("MENU_OPTION_FULLSCREEN")
	_Text_Credits.text = "[center]" + tr("MENU_OPTION_CREDITS")
	_Text_Exit.text = "[center]" + tr("MENU_OPTION_EXIT")

	if play_language == Languages.ENGLISH:
		instance_en = self
	elif play_language == Languages.SPANISH:
		instance_es = self

	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)
	connect("pressed", on_pressed)

	if (TranslationServer.get_locale() == "en" && play_language == Languages.ENGLISH) \
		|| (TranslationServer.get_locale() == "es" && play_language == Languages.SPANISH) \
		|| (TranslationServer.get_locale() != "en" && TranslationServer.get_locale() != "es" && play_language == Languages.ENGLISH):
			if play_language == Languages.ENGLISH:
				TranslationServer.set_locale("en")
			elif play_language == Languages.SPANISH:
				TranslationServer.set_locale("es")
			active = true
			_Text.modulate = ACTIVE_COLOR


func on_pressed() -> void:
	instance_en.active = false
	instance_en._Text.modulate = Color(1, 1, 1, 1)
	instance_es.active = false
	instance_es._Text.modulate = Color(1, 1, 1, 1)
	active = true
	_Text.modulate = ACTIVE_COLOR
	_AudioClick.play()
	if play_language == Languages.ENGLISH:
		TranslationServer.set_locale("en")
	elif play_language == Languages.SPANISH:
		TranslationServer.set_locale("es")
	else:
		assert(false, "No language selected")

	_Text_Play.text = "[center]" + tr("MENU_OPTION_PLAY")
	_Text_English.text = "[center]" + tr("MENU_OPTION_ENGLISH")
	_Text_Spanish.text = "[center]" + tr("MENU_OPTION_SPANISH")
	_Text_Fullscreen.text = "[center]" + tr("MENU_OPTION_FULLSCREEN")
	_Text_Credits.text = "[center]" + tr("MENU_OPTION_CREDITS")
	_Text_Exit.text = "[center]" + tr("MENU_OPTION_EXIT")


func on_mouse_entered() -> void:
	_Text.modulate = Color(0.98, 0.48, 0, 1)
	_AudioHover.play()


func on_mouse_exited() -> void:
	if !active:
		_Text.modulate = Color(1, 1, 1, 1)
	else:
		_Text.modulate = ACTIVE_COLOR
