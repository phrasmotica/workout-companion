@tool
extends MarginContainer

enum IconChoice { TICK, PLAY, PAUSE }

@export
var icon := IconChoice.TICK:
	set(value):
		icon = value

		_refresh()

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

@export_group("Icon Data")

@export
var icons_dictionary: Dictionary[IconChoice, Texture2D] = {}:
	set(value):
		icons_dictionary = value

		_refresh()

@onready
var texture_rect: TextureRect = %TextureRect

func _refresh() -> void:
	if texture_rect:
		texture_rect.visible = not hide_icon
		texture_rect.texture = _get_icon()

	add_theme_constant_override("margin_left", margin)
	add_theme_constant_override("margin_top", margin)
	add_theme_constant_override("margin_right", margin)
	add_theme_constant_override("margin_bottom", margin)

func _get_icon() -> Texture2D:
	return icons_dictionary[icon] if icons_dictionary.has(icon) else null
