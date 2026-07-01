extends Control
@onready var icon_app_node=$icon_app
@onready var popmenu_app_node=$popmenu_app
@onready var window_app_node=$window_app
var dragging:bool=false
var drag_offset:Vector2=Vector2.ZERO
func _ready() -> void:
	module_init()
	pass 
func _process(delta: float) -> void:#处理图标拖拽；限制图标与窗口在屏幕范围内
	if dragging:
		global_position=get_global_mouse_position()-drag_offset
	pass
func popmenu_item_init():
	popmenu_app_node.add_item("eat")
func module_init():#初始化图标尺寸，限制范围等信息
	icon_app_node.custom_minimum_size.x=Env.ICON_SIZE
	icon_app_node.custom_minimum_size.y=Env.ICON_SIZE
	popmenu_item_init()
func _on_icon_app_gui_input(event: InputEvent) -> void:#应用图标响应事件
	#如果事件属于鼠标事件；
	#如果是左键双击，设置拖拽状态为0，显示应用窗口
	#如果是左键单击，单击信号发送期间拖拽状态为1，计算偏移量，直至松开
	#如果是右键单击，弹出气泡菜单
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.double_click:
			dragging=false
			window_app_node.show()
			get_viewport().set_input_as_handled()
			return
		if event.button_index==MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging=true
				drag_offset=get_global_mouse_position()-global_position
				get_viewport().set_input_as_handled()
			else:
				dragging=false
		if event.button_index==MOUSE_BUTTON_RIGHT and event.pressed:
			popmenu_app_node.position=get_global_mouse_position()
			popmenu_app_node.popup()
	pass
func _on_window_app_close_requested() -> void:#接受窗口关闭信号（简单隐藏起来）；继续恢复图标的完全信号接收
	window_app_node.hide()
	pass
func _on_popmenu_app_index_pressed(index: int) -> void:#弹出式菜单事件响应
	if index==0:
		print("eat")
	pass
func _on_pe_t_hunger() -> void:
	popmenu_app_node.get_item_index(0).text="eat......"
	pass # Replace with function body.
