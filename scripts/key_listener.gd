extends Node

signal pressed_start

func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		pressed_start.emit()
