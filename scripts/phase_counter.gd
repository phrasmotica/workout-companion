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

func _handle_workout_changed(_workout: Workout) -> void:
    _refresh()

func _get_step_count() -> int:
    return workout_provider.get_step_count() if workout_provider else 0

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

        if phase_count > i:
            var phase := workout_provider.get_phase(i)

            stepper.footer_text = phase.phase_name
            stepper.starting_number = current_starting_number
            stepper.step_count = phase.sets
            stepper.current_step = current_step - step_offset
            stepper.completed_step = completed_step - step_offset

            step_offset += phase.sets
            current_starting_number += phase.sets

    if steppers.size() > phase_count:
        for i in range(phase_count, steppers.size()):
            print("Cleaning up child %d" % i)
            get_child(i).queue_free()
