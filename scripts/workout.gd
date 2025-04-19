@tool
class_name Workout extends Resource

@export
var sets: int = 1:
    set(value):
        sets = value

        emit_changed()

@export
var reps: int = 20:
    set(value):
        reps = value

        emit_changed()
