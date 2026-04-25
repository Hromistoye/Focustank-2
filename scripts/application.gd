extends Control
@onready var icon_app_node=$icon_app
@onready var popmenu_app_node=$popmenu_app
@onready var window_app_node=$window_app
var dragging:bool=false
var drag_offset:Vector2=Vector2.ZERO
func _ready() -> void:
	icon_app_node.mouse_filter=Control.MOUSE_FILTER_STOP
	pass 
func _process(delta: float) -> void:
	if dragging:
		global_position=get_global_mouse_position()-drag_offset
	pass
func _on_icon_app_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.double_click:
			dragging=false
			window_app_node.size=Vector2(288,167)
			window_app_node.position=Vector2(64,57)
			window_app_node.show()
			icon_app_node.mouse_filter=Control.MOUSE_FILTER_IGNORE
			get_viewport().set_input_as_handled()
			return
		if event.button_index==MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_offset=get_global_mouse_position()-global_position
				dragging=true
				get_viewport().set_input_as_handled()
			else:
				dragging=false
	pass
func _on_window_app_close_requested() -> void:
	window_app_node.hide()
	icon_app_node.mouse_filter=Control.MOUSE_FILTER_STOP
	pass
