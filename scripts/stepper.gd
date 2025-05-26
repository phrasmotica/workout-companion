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
var statuses: Array[StepperStep.Status] = []:
    set(value):
        statuses = value

        _refresh()

@onready
var step_scene: PackedScene = load("res://scenes/stepper_step.tscn")

@onready
var steps_parent: Control = %StepsContainer

@onready
var footer: Label = %Footer

var _current_step := -1

func _ready() -> void:
    _refresh()

func inc() -> void:
    _current_step += 1
    statuses[_current_step] = StepperStep.Status.CURRENT

func complete() -> void:
    statuses[_current_step] = StepperStep.Status.COMPLETED

func stop() -> void:
    var new_statuses: Array[StepperStep.Status] = []

    new_statuses.resize(step_count)
    new_statuses.fill(StepperStep.Status.FUTURE)

    statuses = new_statuses

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
        step.status = _compute_step_status(i)
        step.content = _compute_step_content(step.status)

    if steps.size() > step_count:
        for i in range(step_count, steps.size()):
            # print("Cleaning up child %d" % i)
            steps_parent.get_child(i).queue_free()

func _compute_step_status(index: int) -> StepperStep.Status:
    if index < 0 or index >= statuses.size():
        return StepperStep.Status.FUTURE

    return statuses[index]

func _compute_step_content(status: StepperStep.Status) -> StepperStep.Content:
    if status == StepperStep.Status.COMPLETED:
        return StepperStep.Content.TICK

    if status == StepperStep.Status.SKIPPED:
        return StepperStep.Content.SKIP

    return StepperStep.Content.TEXT
