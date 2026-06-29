extends Label

func _ready():
	text = "拖我！"
	print("1")

func _get_drag_data(at_position: Vector2) -> Variant:
	# 返回要传递的信息
	print("!")
	var data = { "text": text, "color": modulate }
	
	# 创建一个预览标签
	var preview = Label.new()
	preview.text = text
	preview.modulate = Color(1, 0.8, 0.8, 0.8)
	set_drag_preview(preview)
	
	return data
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("鼠标按钮事件: ", event)
	elif event is InputEventMouseMotion:
		pass # 太多，可以暂时不打印
