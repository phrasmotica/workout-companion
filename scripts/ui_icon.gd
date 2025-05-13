@tool
extends MarginContainer

@export
var hide_icon := false:
	set(value):
		hide_icon = value

		_refresh()

@export_range(0, 10)
var margin := 0:
	set(value):
		margin = value

		_refresh()

@onready
var texture_rect: TextureRect = %TextureRect

func _refresh() -> void:
	if texture_rect:
		texture_rect.visible = not hide_icon

	add_theme_constant_override("margin_left", margin)
	add_theme_constant_override("margin_top", margin)
	add_theme_constant_override("margin_right", margin)
	add_theme_constant_override("margin_bottom", margin)
