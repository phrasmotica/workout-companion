@tool
class_name PhaseCounter extends HBoxContainer

@export
var workout_provider: WorkoutProvider:
    set(value):
        workout_provider = value

        if not workout_provider.workout_changed.is_connected(_handle_workout_changed):
            workout_provider.workout_changed.connect(_handle_workout_changed)

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
var stepper_scene: PackedScene = preload("res://scenes/stepper.tscn")

var _current_step := -1

func _ready() -> void:
    _refresh()

func _handle_workout_changed(_workout: Workout) -> void:
    _refresh()

func _get_step_count() -> int:
    return workout_provider.get_step_count() if workout_provider else 0

func inc() -> void:
    _current_step += 1
    statuses[_current_step] = StepperStep.Status.CURRENT

    _refresh()

func complete() -> void:
    statuses[_current_step] = StepperStep.Status.COMPLETED

    _refresh()

func stop() -> void:
    var new_statuses: Array[StepperStep.Status] = []

    new_statuses.resize(_get_step_count())
    new_statuses.fill(StepperStep.Status.FUTURE)

    statuses = new_statuses

func _refresh() -> void:
    if not stepper_scene:
        return

    if not workout_provider:
        return

    var steppers := get_children()

    var current_starting_number = starting_number
    var step_offset := 0

    var phase_count := workout_provider.get_phase_count()

    for i in maxi(phase_count, steppers.size()):
        var stepper: Stepper

        if steppers.size() > i:
            stepper = steppers[i]
        else:
            stepper = stepper_scene.instantiate()
            stepper.name = "Stepper%d" % (i + 1)

            add_child(stepper)
            stepper.owner = self

        stepper.stop()

        if phase_count > i:
            var phase := workout_provider.get_phase(i)

            stepper.footer_text = phase.phase_name
            stepper.starting_number = current_starting_number
            stepper.step_count = phase.sets
            stepper.statuses = statuses.slice(step_offset, step_offset + phase.sets)

            step_offset += phase.sets
            current_starting_number += phase.sets

    if steppers.size() > phase_count:
        for i in range(phase_count, steppers.size()):
            # print("Cleaning up child %d" % i)
            get_child(i).queue_free()
