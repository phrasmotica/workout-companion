@tool
class_name StatusMessage extends VBoxContainer

enum MessageType { PRESS_START, GET_READY, PAUSING }

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

func _refresh() -> void:
    press_to_start_label.visible = message == MessageType.PRESS_START
    get_ready_label.visible = message == MessageType.GET_READY
    pausing_label.visible = message == MessageType.PAUSING
