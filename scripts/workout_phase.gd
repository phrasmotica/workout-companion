@tool
class_name WorkoutPhase extends Resource

@export
var phase_name := "":
    set(value):
        phase_name = value

        emit_changed()

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

@export_range(0, 5)
var rep_duration_seconds: float = 1:
    set(value):
        rep_duration_seconds = value

        emit_changed()

@export
var rep_curve := Flasher.ProgressCurve.LINEAR_OUT:
    set(value):
        rep_curve = value

        emit_changed()

@export
var rep_curve_param := Flasher.ProgressParam.ALPHA:
    set(value):
        rep_curve_param = value

        emit_changed()

@export_range(0, 120)
var pause_duration_seconds: float = 60:
    set(value):
        pause_duration_seconds = value

        emit_changed()
