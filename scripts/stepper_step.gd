@tool
class_name StepperStep extends HBoxContainer

enum Look { FUTURE, CURRENT, COMPLETED }

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

@export
var look := Look.FUTURE:
    set(value):
        look = value

        _refresh()

@export
var default_colour: Color:
    set(value):
        default_colour = value

        _refresh()

@export
var completed_colour: Color:
    set(value):
        completed_colour = value

        _refresh()

@onready
var leading_line: ColorRect = %LeadingLine

@onready
var step_background: PanelContainer = %PanelContainer

@onready
var label: Label = %Label

func _refresh() -> void:
    if leading_line:
        leading_line.visible = show_leading_line
        leading_line.color = _compute_line_colour()

    if step_background:
        step_background.theme_type_variation = _compute_panel_style()

    if label:
        label.text = str(number)

func _compute_line_colour() -> Color:
    if look == Look.COMPLETED:
        return completed_colour

    return default_colour

func _compute_panel_style() -> StringName:
    if look == Look.FUTURE:
        return "FutureStepperPanelContainer"

    if look == Look.COMPLETED:
        return "CompletedStepperPanelContainer"

    return "StepperPanelContainer"
