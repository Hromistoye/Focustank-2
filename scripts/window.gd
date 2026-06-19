extends Window
var limit_rect:=Rect2i()
func _ready() -> void:
	await get_tree().process_frame
	limit_rect=Rect2i(
	Vector2i(Env.SCREEN_LEFT,Env.SCREEN_TOP),
	Vector2i(Env.SCREEN_RIGHT-Env.SCREEN_LEFT,Env.SCREEN_BOTTOM-Env.SCREEN_TOP)
	)
	fit_size_to_limit()
	clamp_decorated_window()
func _process(_delta: float) -> void:
	clamp_decorated_window()

func fit_size_to_limit()->void:
	var deco_size:=get_size_with_decorations()
	var extra:=deco_size-size
	var max_content_size:=limit_rect.size-extra
	max_content_size.x=max(max_content_size.x,1)
	max_content_size.y=max(max_content_size.y,1)
	size=Vector2i(
		min(size.x,max_content_size.x),
		min(size.y,max_content_size.y)
	)
	max_size=max_content_size
func clamp_decorated_window() -> void:
	var deco_pos:=get_position_with_decorations()
	var deco_size:=get_size_with_decorations()
	var offset:=position-deco_pos
	var min_pos:=limit_rect.position
	var max_pos:=limit_rect.end-deco_size
	max_pos.x=max(max_pos.x,min_pos.x)
	max_pos.y=max(max_pos.y,min_pos.y)
	var clamped_deco_pos:=Vector2i(
		clamp(deco_pos.x,min_pos.x,max_pos.x),
		clamp(deco_pos.y,min_pos.y,max_pos.y)
	)
	position=clamped_deco_pos+offset
