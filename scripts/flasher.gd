class_name Flasher extends ColorRect

## The time between flashes.
@export_range(0.1, 5.0)
var wait_time_seconds := 1.0

signal flashed

var _started := false
var _progress := 0.0

func _process(delta: float) -> void:
	if not _started:
		return

	_progress += delta / wait_time_seconds

	if _progress >= 1:
		_progress = 0
		flashed.emit()

	update_alpha()

func start_stop():
	if not _started:
		_started = true
		flashed.emit()
	else:
		stop()

func stop():
	_started = false
	_progress = 0

	update_alpha()

func update_alpha():
	color.a = 1 - _progress

func _on_flash_interval_slider_value_changed(value: float) -> void:
	wait_time_seconds = value
