@tool
class_name Stepper extends VBoxContainer

@export
var footer_text := "":
    set(value):
        footer_text = value

        _refresh()

@export
var step_count := 3:
    set(value):
        step_count = maxi(value, 1)

        _refresh()

@export
var starting_number := 1:
    set(value):
        starting_number = maxi(value, 0)

        _refresh()

@export
var current_step := -1:
    set(value):
        current_step = clampi(value, -1, step_count)

        _refresh()

@export
var completed_step := -1:
    set(value):
        completed_step = clampi(value, -1, current_step)

        _refresh()

@onready
var step_scene: PackedScene = load("res://scenes/stepper_step.tscn")

@onready
var steps_parent: Control = %StepsContainer

@onready
var footer: Label = %Footer

func _ready() -> void:
    _refresh()

func inc() -> void:
    current_step += 1

func complete() -> void:
    completed_step += 1

func stop() -> void:
    current_step = -1
    completed_step = -1

func _refresh() -> void:
    if footer:
        footer.text = footer_text if len(footer_text) > 0 else "<footer>"

    if not step_scene:
        return

    var steps := steps_parent.get_children()

    for i in maxi(step_count, steps.size()):
        var step: StepperStep

        if steps.size() > i:
            step = steps[i]
        else:
            step = step_scene.instantiate()
            step.name = "StepperStep%d" % (i + 1)

            steps_parent.add_child(step)
            step.owner = self

        step.number = starting_number + i
        step.show_leading_line = i > 0
        step.look = _compute_step_look(i)

    if steps.size() > step_count:
        for i in range(step_count, steps.size()):
            print("Cleaning up child %d" % i)
            steps_parent.get_child(i).queue_free()

func _compute_step_look(index: int) -> StepperStep.Look:
    if index < current_step:
        return StepperStep.Look.COMPLETED

    if index == current_step:
        if index > completed_step:
            return StepperStep.Look.CURRENT

        return StepperStep.Look.COMPLETED

    return StepperStep.Look.FUTURE
