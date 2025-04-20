@tool
extends Node2D

@export
var workout: Workout:
	set(value):
		if workout != value:
			workout = value

		if not workout.changed.is_connected(_handle_workout_changed):
			workout.changed.connect(_handle_workout_changed)

@export
var start_immediately := false

@export
var status_message: StatusMessage

@export
var set_counter: Stepper

@export
var rep_counter: RepCounter

@onready
var countdown: Countdown = %Countdown

@onready
var pause_countdown: Countdown = %PauseCountdown

@onready
var flasher: Flasher = %Flasher

var _sets_remaining := 0
var _reps_remaining := 0

func _handle_workout_changed() -> void:
	if set_counter:
		set_counter.step_count = workout.sets

	if rep_counter:
		rep_counter.max_count = workout.reps

	if flasher:
		flasher.wait_time_seconds = workout.rep_duration_seconds

	if pause_countdown:
		pause_countdown.duration_seconds = int(workout.pause_duration_seconds)

func do_countdown():
	if flasher:
		flasher.hide()

		print("do_countdown: hid flasher")

	if countdown:
		countdown.show()
		countdown.start_stop()

		print("do_countdown: started countdown")

	if status_message:
		status_message.show()
		status_message.message = StatusMessage.MessageType.GET_READY

	_sets_remaining = workout.sets

func move_to_flasher():
	if countdown:
		countdown.hide()
		countdown.reset()

		print("move_to_flasher: reset countdown")

	if pause_countdown:
		pause_countdown.hide()
		pause_countdown.reset()

		print("move_to_flasher: reset pause_countdown")

	_reps_remaining = workout.reps

	if flasher:
		flasher.show()
		flasher.start_stop()

		print("move_to_flasher: start_stopped flasher")

	if status_message:
		status_message.hide()

	if rep_counter:
		rep_counter.show()
		rep_counter.stop()

	if set_counter:
		set_counter.inc()

func pause() -> void:
	if flasher:
		flasher.hide()
		flasher.stop()

		print("Stopped flasher")

	if status_message:
		status_message.show()
		status_message.message = StatusMessage.MessageType.PAUSING

	print("Pausing for %d second(s)" % workout.pause_duration_seconds)

	if rep_counter:
		rep_counter.hide()
		rep_counter.stop()

	if pause_countdown:
		pause_countdown.show()
		pause_countdown.start_stop()

func stop() -> void:
	if flasher:
		flasher.hide()
		flasher.stop()

		print("Stopped flasher")

	if status_message:
		status_message.show()
		status_message.message = StatusMessage.MessageType.PRESS_START

	if rep_counter:
		rep_counter.hide()
		rep_counter.stop()

	if set_counter:
		set_counter.stop()

func _on_flasher_flashed() -> void:
	if _reps_remaining <= 0:
		_sets_remaining -= 1

		if _sets_remaining <= 0:
			print("Finished last set, stopping")

			stop()

		else:
			print("%d set(s) remaining" % _sets_remaining)

			pause()
	else:
		_reps_remaining -= 1

		print("%d reps remaining" % _reps_remaining)

		if rep_counter:
			rep_counter.inc()

func _on_countdown_finished() -> void:
	print("Countdown finished, moving to flasher")

	move_to_flasher()

func _on_countdown_cancelled() -> void:
	print("Countdown cancelled")

func _on_key_listener_pressed_start() -> void:
	if start_immediately:
		print("Starting immediately")

		move_to_flasher()
	else:
		print("Doing countdown before starting")

		do_countdown()
