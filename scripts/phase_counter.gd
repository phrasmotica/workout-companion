@tool
class_name PhaseCounter extends HBoxContainer

@export
var workout: Workout:
    set(value):
        workout = value

        _refresh()

@onready
var stepper_scene: PackedScene = preload("res://scenes/stepper.tscn")

func _refresh() -> void:
    if not stepper_scene:
        return

    if not workout:
        return

    var steppers := get_children()

    var starting_number = 1

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

            stepper.starting_number = starting_number
            stepper.step_count = phase.sets

            starting_number += phase.sets

    if steppers.size() > workout.phases.size():
        for i in range(workout.phases.size(), steppers.size()):
            print("Cleaning up child %d" % i)
            get_child(i).queue_free()
