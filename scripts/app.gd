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
var state_machine: StateMachine

@export
var workout_state: WorkoutState

@export
var ui_updater: UIUpdater

func _ready() -> void:
	assert(state_machine)
	assert(ui_updater)

func _handle_workout_changed(_workout: Workout) -> void:
	_refresh()

func _refresh() -> void:
	if not workout_state:
		return

	if ui_updater:
		ui_updater.inject_title(workout_state.get_title())
		ui_updater.inject_countdown(workout_state.get_countdown_time())

		var first_phase := workout_state.get_next_phase()
		if first_phase:
			# UI updater might be null here
			ui_updater.inject_phase(first_phase)

func to_countdown() -> void:
	workout_state.to_first_phase()

	state_machine.to_countdown()

func to_in_progress() -> void:
	workout_state.start_phase()

	state_machine.to_in_progress()

func to_pausing() -> void:
	var phase := workout_state.get_phase()

	print("Pausing for %d second(s)" % phase.pause_duration_seconds)

	state_machine.to_pausing(phase.pause_duration_seconds)

func to_ready() -> void:
	print("Stopping")

	state_machine.to_ready()

func to_finished() -> void:
	print("Finished")

	state_machine.to_finished()

func _can_start() -> bool:
	return state_machine.is_ready() or state_machine.is_finished()

func _on_flasher_flashed() -> void:
	if Engine.is_editor_hint():
		return

	if workout_state.is_finished():
		return

	if workout_state.is_set_finished():
		workout_state.to_next_set()

		if workout_state.is_phase_finished():
			print("Finished last set of phase %d" % workout_state.current_phase)

			workout_state.to_next_phase()

			if workout_state.is_finished():
				to_finished()
			else:
				ui_updater.inject_phase(workout_state.get_phase())

				to_pausing()
		else:
			to_pausing()
	else:
		workout_state.to_next_rep()

		ui_updater.add_rep()

func _on_countdown_finished() -> void:
	print("Countdown finished, moving to flasher")

	to_in_progress()

func _on_countdown_cancelled() -> void:
	print("Countdown cancelled")

func _on_key_listener_pressed_start() -> void:
	if not _can_start():
		print("Cannot start - already in state %d" % state_machine.state)
		return

	workout_state.reset_all()

	if start_immediately:
		print("Starting immediately")

		to_in_progress()
	else:
		print("Doing countdown before starting")

		to_countdown()
