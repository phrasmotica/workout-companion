@tool
class_name Flasher extends HBoxContainer

enum ProgressCurve { LINEAR_OUT, LINEAR_IN_OUT, EASE_IN_OUT }

enum ProgressParam { ALPHA, WIDTH, HEIGHT }

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

@onready
var width_container: VBoxContainer = %WidthContainer

@onready
var width_spacer: Control = %WidthSpacer

@onready
var height_container: VBoxContainer = %HeightContainer

@onready
var height_spacer: Control = %HeightSpacer

@onready
var color_rect: ColorRect = %ColorRect

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
	if color_rect:
		color_rect.color.a = _compute_alpha()

	var width_ratio := _compute_width_ratio()

	if width_container:
		width_container.size_flags_stretch_ratio = width_ratio

	if width_spacer:
		width_spacer.size_flags_stretch_ratio = 1.0 - width_ratio

	var height_ratio := _compute_height_ratio()

	if height_container:
		height_container.size_flags_stretch_ratio = height_ratio

	if height_spacer:
		height_spacer.size_flags_stretch_ratio = 1.0 - height_ratio

func _compute_alpha() -> float:
	if progress_param == ProgressParam.ALPHA:
		return _sample_curve()

	return 1.0

func _compute_width_ratio() -> float:
	if progress_param == ProgressParam.WIDTH:
		return _sample_curve()

	return 1.0

func _compute_height_ratio() -> float:
	if progress_param == ProgressParam.HEIGHT:
		return _sample_curve()

	return 1.0

func _sample_curve() -> float:
	if curves.has(progress_curve):
		return curves[progress_curve].sample(progress)

	return 1.0

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
