@tool
extends Node2D

@export
var start_immediately := false

@export
var workout_provider: WorkoutProvider:
	set(value):
		workout_provider = value

		if not workout_provider.workout_changed.is_connected(_handle_workout_changed):
			workout_provider.workout_changed.connect(_handle_workout_changed)

		_refresh()

@export
var ui_updater: UIUpdater

# HIGH: move all of the state-machine transitions into a dedicated script that
# emits signals when the transitions happen. Then react to those signals in
# this script.

var _current_phase := -1
var _sets_remaining := 0
var _reps_remaining := 0

func _ready() -> void:
	assert(ui_updater)

func _handle_workout_changed(_workout: Workout) -> void:
	_refresh()

func _refresh() -> void:
	if not workout_provider:
		return

	_current_phase = -1
	_sets_remaining = 0
	_reps_remaining = 0

	var phase := workout_provider.get_phase(0)

	if phase and ui_updater:
		# UI updater might be null here
		ui_updater.inject_phase(phase)

func to_countdown() -> void:
	_current_phase = 0

	var phase := workout_provider.get_phase(_current_phase)
	_sets_remaining = phase.sets

	ui_updater.to_countdown()

func to_in_progress() -> void:
	var phase := workout_provider.get_phase(_current_phase)
	_reps_remaining = phase.reps

	ui_updater.to_in_progress()

func to_pausing() -> void:
	var phase := workout_provider.get_phase(_current_phase)

	print("Pausing for %d second(s)" % phase.pause_duration_seconds)

	ui_updater.to_pausing(phase.pause_duration_seconds)

func to_ready() -> void:
	print("Stopping")

	ui_updater.to_ready()

func _on_flasher_flashed() -> void:
	if _reps_remaining <= 0:
		_sets_remaining -= 1

		if _sets_remaining <= 0:
			print("Finished last set of phase %d" % _current_phase)

			_current_phase += 1

			if _current_phase >= workout_provider.get_phase_count():
				to_ready()
			else:
				print("%d set(s) remaining" % _sets_remaining)

				var next_phase := workout_provider.get_phase(_current_phase)

				_sets_remaining = next_phase.sets

				ui_updater.inject_phase(next_phase)

				to_pausing()
		else:
			print("%d set(s) remaining" % _sets_remaining)

			to_pausing()
	else:
		_reps_remaining -= 1

		print("%d reps remaining" % _reps_remaining)

		ui_updater.add_rep()

func _on_countdown_finished() -> void:
	print("Countdown finished, moving to flasher")

	to_in_progress()

func _on_countdown_cancelled() -> void:
	print("Countdown cancelled")

func _on_key_listener_pressed_start() -> void:
	if start_immediately:
		print("Starting immediately")

		to_in_progress()
	else:
		print("Doing countdown before starting")

		to_countdown()
