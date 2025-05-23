@tool
class_name Flasher extends ColorRect

## The time between flashes.
@export_range(0.1, 5.0)
var wait_time_seconds := 1.0

@export
var started := false:
	set(value):
		started = value

		progress = 0.0

		_refresh()

@export_range(0.0, 1.0)
var progress := 0.0:
	set(value):
		progress = value

		_refresh()

signal flashed

func _process(delta: float) -> void:
	if not started:
		return

	progress += delta / wait_time_seconds

	if progress >= 1.0:
		progress = 0.0
		flashed.emit()

func _refresh() -> void:
	color.a = 1.0 - progress

func start_stop() -> void:
	if not started:
		started = true
		flashed.emit()
	else:
		started = false

func stop() -> void:
	started = false
