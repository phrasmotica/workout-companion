@tool
class_name RepCounter extends VBoxContainer

@export
var count := 0:
    set(value):
        count = clampi(value, 0, max_count)

        _refresh()

@export
var max_count := 0:
    set(value):
        max_count = value

        _refresh()

@onready
var label: Label = %Label

func inc() -> void:
    count += 1

func stop() -> void:
    count = 1

func _refresh() -> void:
    if label:
        label.text = "Rep %d of %d" % [count, max_count]
