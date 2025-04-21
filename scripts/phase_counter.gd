@tool
class_name PhaseCounter extends HBoxContainer

@export
var workout: Workout:
    set(value):
        workout = value

        _refresh()

@export
var starting_number := 1:
    set(value):
        starting_number = maxi(value, 0)

        _refresh()

@export
var current_step := -1:
    set(value):
        current_step = clampi(value, -1, _get_step_count())

        _refresh()

@export
var completed_step := -1:
    set(value):
        completed_step = clampi(value, -1, current_step)

        _refresh()

@onready
var stepper_scene: PackedScene = preload("res://scenes/stepper.tscn")

func _ready() -> void:
    _refresh()

func _get_step_count() -> int:
    return workout.phases \
        .map(func(p: WorkoutPhase): return p.sets) \
        .reduce(func(accum: int, current: int): return accum + current)

func inc() -> void:
    current_step += 1

func complete() -> void:
    completed_step += 1

func stop() -> void:
    current_step = -1
    completed_step = -1

func _refresh() -> void:
    if not stepper_scene:
        return

    if not workout:
        return

    var steppers := get_children()

    var current_starting_number = starting_number
    var step_offset := 0

    for i in maxi(workout.phases.size(), steppers.size()):
        var stepper: Stepper

        if steppers.size() > i:
            stepper = steppers[i]
        else:
            stepper = stepper_scene.instantiate()
            stepper.name = "Stepper%d" % (i + 1)

            add_child(stepper)
            stepper.owner = self

        if workout.phases.size() > i:
            var phase := workout.phases[i]

            stepper.starting_number = current_starting_number
            stepper.step_count = phase.sets
            stepper.current_step = current_step - step_offset
            stepper.completed_step = completed_step - step_offset

            step_offset += phase.sets
            current_starting_number += phase.sets

    if steppers.size() > workout.phases.size():
        for i in range(workout.phases.size(), steppers.size()):
            print("Cleaning up child %d" % i)
            get_child(i).queue_free()
