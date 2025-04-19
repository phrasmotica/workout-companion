@tool
class_name StepperStep extends HBoxContainer

@export
var number := 1:
    set(value):
        number = maxi(value, 0)

        _refresh()

@export
var show_leading_line := false:
    set(value):
        show_leading_line = value

        _refresh()

@onready
var leading_line: ColorRect = %LeadingLine

@onready
var label: Label = %Label

func _refresh() -> void:
    if leading_line:
        leading_line.visible = show_leading_line

    if label:
        label.text = str(number)
