extends Camera2D
class_name SniperCameraController


@onready var idle_position := position
@onready var _Scope: Sprite2D = get_node("Scope")
@onready var _Hint: Node2D = get_node("Hint")
@onready var _Hint_Text: RichTextLabel = get_node("Hint/Text")
@onready var _AimItemName: RichTextLabel = get_node("AimItemName")
@onready var _AnimationPlayer: AnimationPlayer = get_node("AnimationPlayer")


const OFFSET_SCOPE := Vector2(185, 35)
const CAMERA_ZOOM_IN := 2.0
const CAMERA_ZOOM_OUT := 1.0


func shoot() -> void:
	_AnimationPlayer.play("shoot")


func shoot_fast() -> void:
	_AnimationPlayer.play("shoot_fast")


func show_scope(next_position: Vector2) -> void:
	zoom = Vector2(CAMERA_ZOOM_IN, CAMERA_ZOOM_IN)
	_Scope.scale = Vector2(1/CAMERA_ZOOM_IN, 1/CAMERA_ZOOM_IN)
	_Scope.visible = true
	_AimItemName.visible = true
	set_camera_position(next_position)


func hide_scope() -> void:
	_AnimationPlayer.play("RESET")
	zoom = Vector2(CAMERA_ZOOM_OUT, CAMERA_ZOOM_OUT)
	_Scope.scale = Vector2(1/CAMERA_ZOOM_OUT, 1/CAMERA_ZOOM_OUT)
	_Scope.visible = false
	_AimItemName.visible = false
	_AimItemName.text = ""
	_Hint.visible = false
	reset_position()


func reset_position() -> void:
	position = idle_position


func set_camera_position(new_position: Vector2) -> void:
	position = new_position
	var viewport_rect := get_viewport_rect().size
	position = Vector2(
		clamp(position.x, OFFSET_SCOPE.x, viewport_rect.x - OFFSET_SCOPE.x),
		clamp(position.y, OFFSET_SCOPE.y, viewport_rect.y - OFFSET_SCOPE.y)
	)
