@tool
class_name StateMachine extends Node

enum State { READY, COUNTDOWN, IN_PROGRESS, PAUSING, FINISHED }

@export
var state := State.READY

signal entered_ready
signal entered_countdown
signal entered_in_progress
signal entered_pausing(duration_seconds: float)
signal entered_finished

func to_ready() -> void:
	state = State.READY

	entered_ready.emit()

func to_countdown() -> void:
	state = State.COUNTDOWN

	entered_countdown.emit()

func to_in_progress() -> void:
	state = State.IN_PROGRESS

	entered_in_progress.emit()

func to_pausing(duration_seconds: float) -> void:
	state = State.PAUSING

	entered_pausing.emit(duration_seconds)

func to_finished() -> void:
	state = State.FINISHED

	entered_finished.emit()

func is_ready() -> bool:
	return state == State.READY

func is_finished() -> bool:
	return state == State.FINISHED
