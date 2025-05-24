@tool
class_name StatusMessage extends VBoxContainer

enum MessageType { PRESS_START, GET_READY, PAUSING, FINISHED }

@export
var message := MessageType.PRESS_START:
	set(value):
		message = value

		_refresh()

@onready
var press_to_start_label: Label = %PressToStartLabel

@onready
var get_ready_label: Label = %GetReadyLabel

@onready
var pausing_label: Label = %PausingLabel

@onready
var finished_label: Label = %FinishedLabel

func _refresh() -> void:
	if press_to_start_label:
		press_to_start_label.visible = message == MessageType.PRESS_START

	if get_ready_label:
		get_ready_label.visible = message == MessageType.GET_READY

	if pausing_label:
		pausing_label.visible = message == MessageType.PAUSING

	if finished_label:
		finished_label.visible = message == MessageType.FINISHED
