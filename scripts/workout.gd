@tool
class_name Workout extends Resource

@export
var phases: Array[WorkoutPhase] = []:
    set(value):
        phases = value

        emit_changed()

        for p in phases:
            if not p.changed.is_connected(emit_changed):
                p.changed.connect(emit_changed)
