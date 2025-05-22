@tool
class_name WorkoutProvider extends Node

@export
var workout: Workout:
	set(value):
		workout = value

		if not workout.changed.is_connected(_emit_changed):
			workout.changed.connect(_emit_changed)

		workout_changed.emit(workout)

signal workout_changed(workout: Workout)

func _emit_changed() -> void:
	workout_changed.emit(workout)

func get_countdown_time() -> float:
	return workout.countdown_duration_seconds if workout else 0.0

func get_phase(index: int) -> WorkoutPhase:
	if not workout:
		return null

	if index < 0 or index >= workout.phases.size():
		return null

	return workout.phases[index]

func get_phase_count() -> int:
	return workout.phases.size() if workout else 0

func get_step_count() -> int:
	if not workout:
		return 0

	return workout.phases \
		.map(func(p: WorkoutPhase): return p.sets) \
		.reduce(func(accum: int, current: int): return accum + current)
