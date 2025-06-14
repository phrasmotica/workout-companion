extends Node

signal pressed_start
signal pressed_toggle_mouse_visibility

func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		pressed_start.emit()

	if Input.is_action_just_released("toggle_mouse_visibility"):
		pressed_toggle_mouse_visibility.emit()
