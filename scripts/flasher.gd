@tool
class_name Flasher extends ColorRect

enum ProgressCurve { LINEAR_OUT, LINEAR_IN_OUT }

enum ProgressParam { ALPHA, WIDTH }

## The time between flashes.
@export_range(0.1, 5.0)
var wait_time_seconds := 1.0

@export
var progress_curve := ProgressCurve.LINEAR_OUT:
	set(value):
		progress_curve = value

		_refresh()

@export
var progress_param := ProgressParam.ALPHA:
	set(value):
		progress_param = value

		_refresh()

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

@export_group("Internal")

@export
var curves: Dictionary[ProgressCurve, Curve] = {}:
	set(value):
		curves = value

		_refresh()

var _base_width := 0.0

signal flashed

func _ready() -> void:
	_base_width = size.x

	_refresh()

func _process(delta: float) -> void:
	if not started:
		return

	progress += delta / wait_time_seconds

	if progress >= 1.0:
		progress = 0.0
		flashed.emit()

func _refresh() -> void:
	color.a = _compute_alpha()
	size.x = _compute_width()

func _compute_alpha() -> float:
	if progress_param == ProgressParam.ALPHA:
		return curves[progress_curve].sample(progress)

	return 1.0

func _compute_width() -> float:
	if progress_param == ProgressParam.WIDTH:
		return _base_width * curves[progress_curve].sample(progress)

	return _base_width

func start_stop() -> void:
	if not started:
		started = true
		flashed.emit()
	else:
		started = false

func stop() -> void:
	started = false

func _on_resized() -> void:
	if not started:
		_base_width = size.x
