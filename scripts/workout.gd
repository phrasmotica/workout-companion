@tool
class_name Workout extends Resource

@export_range(0, 60)
var countdown_duration_seconds: float = 30:
    set(value):
        countdown_duration_seconds = value

        emit_changed()

@export
var phases: Array[WorkoutPhase] = []:
    set(value):
        phases = value

        emit_changed()

        for p in phases:
            if not p.changed.is_connected(emit_changed):
                p.changed.connect(emit_changed)
