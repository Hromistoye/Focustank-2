extends Label

func _ready():
	text = "放到这里"

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# 允许任何有 "text" 字段的数据
	return data is Dictionary and data.has("text")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	# 收到数据后，更新自己的文本和颜色
	text = data["text"] + "（已接收）"
	modulate = data.get("color", Color.WHITE)
