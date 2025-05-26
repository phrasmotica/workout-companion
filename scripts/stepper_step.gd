@tool
class_name StepperStep extends HBoxContainer

enum Status { FUTURE, CURRENT, COMPLETED, SKIPPED }

enum Content { NONE, TEXT, TICK, SKIP }

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
var status := Status.FUTURE:
    set(value):
        status = value

        _refresh()

@export
var content := Content.TEXT:
    set(value):
        content = value

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

@onready
var tick_icon: Control = %TickIcon

@onready
var skip_icon: Control = %SkipIcon

func _refresh() -> void:
    if leading_line:
        leading_line.visible = show_leading_line
        leading_line.color = _compute_line_colour()

    if step_background:
        step_background.theme_type_variation = _compute_panel_style()

    if label:
        label.visible = content == Content.TEXT
        label.text = str(number)

    if tick_icon:
        tick_icon.visible = content == Content.TICK

    if skip_icon:
        skip_icon.visible = content == Content.SKIP

func _compute_line_colour() -> Color:
    if status == Status.COMPLETED:
        return completed_colour

    return default_colour

func _compute_panel_style() -> StringName:
    if status == Status.FUTURE:
        return "FutureStepperPanelContainer"

    if status == Status.COMPLETED:
        return "CompletedStepperPanelContainer"

    if status == Status.SKIPPED:
        return "SkippedStepperPanelContainer"

    return "StepperPanelContainer"
