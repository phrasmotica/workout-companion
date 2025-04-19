@tool
class_name Stepper extends HBoxContainer

@export
var step_count := 3:
    set(value):
        step_count = maxi(value, 1)

        _refresh()

@export
var starting_number := 3:
    set(value):
        starting_number = maxi(value, 0)

        _refresh()

@export
var highlighted_step := 1:
    set(value):
        highlighted_step = clampi(value, 1, step_count)

        _refresh()

@onready
var step_scene: PackedScene = load("res://scenes/stepper_step.tscn")

func _ready() -> void:
    _refresh()

func _refresh() -> void:
    if not step_scene:
        return

    var steps := get_children()

    for i in maxi(step_count, steps.size()):
        var step: StepperStep

        if steps.size() > i:
            step = steps[i]
        else:
            step = step_scene.instantiate()
            step.name = "StepperStep%d" % (i + 1)

            add_child(step)
            step.owner = self

        step.number = starting_number + i
        step.show_leading_line = i > 0
        step.highlighted = i + 1 <= highlighted_step

    if steps.size() > step_count:
        for i in range(step_count, steps.size()):
            print("Cleaning up child %d" % i)
            get_child(i).queue_free()
