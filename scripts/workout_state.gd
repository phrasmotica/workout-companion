@tool
class_name WorkoutState extends Node

@export
var workout_provider: WorkoutProvider

@export
var current_phase := -1:
	set(value):
		var phase_count := workout_provider.get_phase_count()
		current_phase = clampi(value, -1, phase_count) # allow going over by 1

var _sets_remaining := 0
var _reps_remaining := 0

func get_countdown_time() -> float:
	return workout_provider.get_countdown_time()

func get_phase() -> WorkoutPhase:
	if not workout_provider:
		return null

	return workout_provider.get_phase(current_phase)

func get_next_phase() -> WorkoutPhase:
	if not workout_provider:
		return null

	return workout_provider.get_phase(current_phase + 1)

func is_finished() -> bool:
	return current_phase >= workout_provider.get_phase_count()

func is_phase_finished() -> bool:
	return _sets_remaining <= 0

func is_set_finished() -> bool:
	return _reps_remaining <= 0

func to_first_phase() -> void:
	current_phase = 0

	var phase := get_phase()
	if phase:
		_sets_remaining = phase.sets

func start_phase() -> void:
	var phase := get_phase()
	if phase:
		_reps_remaining = phase.reps

func to_next_phase() -> void:
	current_phase += 1

	var phase := get_phase()
	if phase:
		_sets_remaining = phase.sets

func to_next_set() -> void:
	_sets_remaining -= 1

	print("%d set(s) remaining" % _sets_remaining)

func to_next_rep() -> void:
	_reps_remaining -= 1

	print("%d reps remaining" % _reps_remaining)

func reset_all() -> void:
	current_phase = -1
	_sets_remaining = 0
	_reps_remaining = 0
