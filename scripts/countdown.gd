class_name Countdown extends ProgressBar

@export
var duration_seconds := 3

@onready
var timer: Timer = %Timer

signal finished
signal cancelled

func _ready():
	reset()

func start():
	if timer:
		timer.start()

func start_stop():
	if not timer:
		return

	if timer.time_left > 0:
		timer.stop()

		cancelled.emit()
	else:
		start()

func reset():
	value = 0

func _on_timer_timeout() -> void:
	value += 1

	if value >= duration_seconds and timer:
		timer.stop()

		finished.emit()
