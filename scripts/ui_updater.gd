@tool
class_name UIUpdater extends Node

@export
var state_machine: StateMachine

@export_group("UI Controls")

@export
var title_label: Label

@export
var phase_counter: PhaseCounter

@export
var status_message: StatusMessage

@export
var rep_counter: RepCounter

@export
var countdown: Countdown

@export
var pause_countdown: Countdown

@export
var flasher: Flasher

func _ready() -> void:
	if state_machine:
		state_machine.entered_countdown.connect(to_countdown)
		state_machine.entered_in_progress.connect(to_in_progress)
		state_machine.entered_pausing.connect(to_pausing)
		state_machine.entered_ready.connect(to_ready)

func inject_title(title: String) -> void:
	if title_label:
		title_label.text = title

func inject_countdown(duration_seconds: float) -> void:
	if countdown:
		countdown.duration_seconds = int(duration_seconds)

func inject_phase(phase: WorkoutPhase) -> void:
	if rep_counter:
		rep_counter.max_count = phase.reps

	if flasher:
		flasher.wait_time_seconds = phase.rep_duration_seconds
		flasher.progress_curve = phase.rep_curve
		flasher.progress_param = phase.rep_curve_param

	if pause_countdown:
		pause_countdown.duration_seconds = int(phase.pause_duration_seconds)

func add_rep() -> void:
	if rep_counter:
		rep_counter.inc()

func to_countdown() -> void:
	if flasher:
		flasher.hide()

		print("to_countdown: hid flasher")

	if countdown:
		countdown.show()
		countdown.start_stop()

		print("to_countdown: started countdown")

	if status_message:
		status_message.show()
		status_message.message = StatusMessage.MessageType.GET_READY

func to_in_progress() -> void:
	if countdown:
		countdown.hide()
		countdown.reset()

		print("to_in_progress: reset countdown")

	if pause_countdown:
		pause_countdown.hide()
		pause_countdown.reset()

		print("to_in_progress: reset pause_countdown")

	if flasher:
		flasher.show()
		flasher.start_stop()

		print("to_in_progress: start_stopped flasher")

	if status_message:
		status_message.hide()

	if rep_counter:
		rep_counter.show()
		rep_counter.stop()

	if phase_counter:
		phase_counter.inc()

func to_pausing(duration_seconds: float) -> void:
	if flasher:
		flasher.hide()
		flasher.stop()

		print("to_pausing: stopped flasher")

	if status_message:
		status_message.show()
		status_message.message = StatusMessage.MessageType.PAUSING

	if rep_counter:
		rep_counter.hide()
		rep_counter.stop()

	if pause_countdown:
		pause_countdown.duration_seconds = int(duration_seconds)
		pause_countdown.show()
		pause_countdown.start_stop()

	if phase_counter:
		phase_counter.complete()

func to_ready() -> void:
	if flasher:
		flasher.hide()
		flasher.stop()

		print("to_ready: stopped flasher")

	if status_message:
		status_message.show()
		status_message.message = StatusMessage.MessageType.PRESS_START

	if rep_counter:
		rep_counter.hide()
		rep_counter.stop()

	if phase_counter:
		phase_counter.stop()
