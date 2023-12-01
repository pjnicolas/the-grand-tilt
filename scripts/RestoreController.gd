extends Node2D


func on_animation_end() -> void:
	Global.corrupt = false
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
