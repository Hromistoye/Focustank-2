extends Control
@onready var icon_app_node=$icon_app
@onready var popmenu_app_node=$popmenu_app
@onready var window_app_node=$window_app

var dragging:bool=false
var drag_offset:Vector2=Vector2.ZERO

func _ready() -> void:
	icon_app_node.mouse_filter=Control.MOUSE_FILTER_STOP
	module_init()
	pass 
func _process(delta: float) -> void:#处理图标拖拽；限制图标与窗口在屏幕范围内
	window_app_node.position.x=clamp(window_app_node.position.x,Env.SCREEN_LEFT,Env.SCREEN_RIGHT-window_app_node.size.x)
	window_app_node.position.y=clamp(window_app_node.position.y,Env.SCREEN_TOP+Env.WINDOW_TITLE_BAR_WIDTH,Env.SCREEN_BOTTOM-window_app_node.size.y)
	if dragging:
		global_position=get_global_mouse_position()-drag_offset
		global_position.x=clamp(global_position.x,Env.SCREEN_LEFT,Env.SCREEN_RIGHT-Env.ICON_SIZE)
		global_position.y=clamp(global_position.y,Env.SCREEN_TOP,Env.SCREEN_BOTTOM-Env.ICON_SIZE)
	pass

func module_init():#初始化各控件尺寸，位置等信息
	icon_app_node.custom_minimum_size.x=Env.ICON_SIZE
	icon_app_node.custom_minimum_size.y=Env.ICON_SIZE
	
	window_app_node.size=Vector2(Env.SCREEN_RIGHT-Env.SCREEN_LEFT,Env.SCREEN_BOTTOM-Env.SCREEN_TOP)
	window_app_node.position=Vector2(Env.SCREEN_LEFT,Env.SCREEN_TOP+Env.WINDOW_TITLE_BAR_WIDTH)
func _on_icon_app_gui_input(event: InputEvent) -> void:#应用图标响应事件
	#如果事件属于鼠标事件；
	#如果是左键双击，设置拖拽状态为0，显示应用窗口
	#如果是左键单击，单击信号发送期间拖拽状态为1，计算偏移量，直至松开
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.double_click:
			dragging=false
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
func _on_window_app_close_requested() -> void:#接受窗口关闭信号（简单隐藏起来）；继续恢复图标的完全信号接收
	window_app_node.hide()
	icon_app_node.mouse_filter=Control.MOUSE_FILTER_STOP
	pass
