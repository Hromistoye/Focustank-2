extends HFlowContainer
@onready var file_item_node=$file_item_FileSystemApp
const FILE_ITEM_SCENE=preload("res://scenes/file_item_FileSystemApp.tscn")#文件视图单个文件项的数据结构
const INIT_PATH="user://"
var isstaying:bool=true
var current_files_will_draw:Array=[]
var last_files_will_draw:Array=[]
var current_path:String=""
var current_file_item:Control=null
var current_act_file_item_name:String=""
var current_file_item_new_name:String=""
func _ready() -> void:
	init_current_ui_tree()
	resize_file_item()
	pass
func _process(delta: float) -> void:
	if isstaying:
		scan_current_ui_tree()
		if last_files_will_draw!=current_files_will_draw:
			draw_current_ui_tree()
	pass
func init_current_ui_tree():#扫描，更新文件名数组；绘制文件视图
	open_init_path()
	scan_current_ui_tree()
	draw_current_ui_tree()
	
func open_init_path():#标记初始目录
	current_path=INIT_PATH
	var current_dir=DirAccess.open(current_path)
	if not INIT_PATH:
		return
func scan_current_ui_tree():
	#依照当前路径打开一个可用目录结构；
	#清空旧数据;
	#格式化处理并装入可绘制信息
	var current_dir=DirAccess.open(current_path)#重定向当前目录
	if not current_dir:
		return
	current_dir.include_hidden=true
	last_files_will_draw=current_files_will_draw.duplicate()
	current_files_will_draw.clear()
	current_dir.list_dir_begin()
	var file_name=current_dir.get_next()
	while file_name!="":
		var file_path=current_path.path_join(file_name)
		var is_directory=current_dir.current_is_dir()
		current_files_will_draw.append({
			"name":file_name,
			"path":file_path,
			"is_dir":is_directory
		})
		file_name=current_dir.get_next()
	current_dir.list_dir_end()
func draw_current_ui_tree():
	#清空视图
	#依照可绘制信息依次绘制
	#链接绘制图标的响应信号
	for child in get_children():
		if child != file_item_node:
			child.queue_free()
	for file_info in current_files_will_draw:
		var file_item=FILE_ITEM_SCENE.instantiate()
		var item_icon:Texture2D
		var item_type:String
		if file_info["is_dir"]:
			item_type="folder"
			item_icon=preload("res://assets/icon4.png")
		else:
			item_type="file"
			item_icon=preload("res://assets/icon3.png")
		file_item.setup(
			file_info["name"],
			file_info["path"],
			item_type,
			item_icon,
		)
		add_child(file_item)
		file_item.find_child("icon_file_item").gui_input.connect(_on_file_item_file_system_app_gui_input.bind(file_item))
		file_item.emit_file_item_new_name.connect(_on_file_item_file_system_app_emit_file_item_new_name)
func _on_file_item_file_system_app_gui_input(event: InputEvent,the_item) -> void:
	if event is InputEventMouseButton:
		current_file_item=the_item
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			if event.double_click:
				if the_item.file_type=="folder":
					var new_path=current_path.path_join(the_item.file_name)
					var new_dir=DirAccess.open(new_path)
					if not new_dir:
						return
					isstaying=false
					current_path=new_path
					scan_current_ui_tree()
					draw_current_ui_tree()
					isstaying=true
			else:
				current_act_file_item_name=the_item.file_name
				var file_item_pos=file_item_node.position
				file_item_node.popmenu_file_item.popup()
				file_item_node.popmenu_file_item.position=file_item_pos
	pass 

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_RIGHT and event.pressed:
			var parent_path=current_path.get_base_dir()
			var parent_dir=DirAccess.open(parent_path)
			if not parent_path:
				return
			isstaying=false
			current_path=parent_path
			scan_current_ui_tree()
			draw_current_ui_tree()
			isstaying=true
	pass
func _on_file_item_file_system_app_emit_file_item_act_index(file_item_act_index: Variant) -> void:
	if file_item_act_index==0:#rename
		current_file_item.name_file_item_node.hide()
		current_file_item.name_input_file_item_node.show()
	if file_item_act_index==1:#copy
		var current_dir=DirAccess.open(current_path)
		if not current_dir:
			return
		var src_path=current_path.path_join(current_act_file_item_name)
		var isdir=DirAccess.dir_exists_absolute(src_path)
		if isdir:
			var dst_path=src_path+"_copy"
			copy_directory(src_path,dst_path)
		else:
			var base=src_path.get_basename()
			var ext=src_path.get_extension()
			var dst_path=base+"_copy."+ext if ext else base+"_copy"
			DirAccess.copy_absolute(src_path,dst_path)
	elif file_item_act_index==2:#eat
		var will_eat_path=current_path.path_join(current_act_file_item_name)
		var isdir=DirAccess.dir_exists_absolute(will_eat_path)
		if isdir:
			remove_directory(will_eat_path)
		else:
			DirAccess.remove_absolute(will_eat_path)
		current_act_file_item_name=""
		
func copy_directory(src_path:String,dst_path:String):
	var src_dir=DirAccess.open(src_path)
	if not src_dir:
		return
	src_dir.list_dir_begin()
	var file_name=src_dir.get_next()
	while file_name!="":
		if file_name=="." or file_name=="..":
			file_name=src_dir.get_next()
		var src_file_path=src_path.path_join(file_name)
		var dst_file_path=dst_path.path_join(file_name)
		if src_dir.current_is_dir():
			copy_directory(src_file_path,dst_file_path)
		else:
			src_dir.copy(src_file_path,dst_file_path)
		file_name=src_dir.get_next()
	src_dir.list_dir_end()
	pass
func remove_directory(path: String):
	var dir=DirAccess.open(path)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name=dir.get_next()
	while file_name!="":
		if file_name=="." or file_name=="..":
			file_name=dir.get_next()
			continue
		var file_path=path.path_join(file_name)
		if dir.current_is_dir():
			remove_directory(file_path)
		else:
			DirAccess.remove_absolute(file_path)
		file_name=dir.get_next()
	dir.list_dir_end()
func _on_file_item_file_system_app_emit_file_item_new_name(new_name: String) -> void:
	var src_path=current_path.path_join(current_act_file_item_name)
	var dst_path=current_path.path_join(new_name)
	
	DirAccess.rename_absolute(src_path,dst_path)
func resize_file_item():
	var max_width=0.0
	var max_height=0.0
	var font=file_item_node.name_file_item_node.get_theme_font("font")
	var font_size=file_item_node.name_file_item_node.get_theme_font_size("font_size")
	for item in get_children():
		var text=item.name_file_item_node.text
		var string_size=font.get_string_size(text,font_size)
		var padding=item.name_file_item_node.get_theme_constant("text_padding")*2
		var total_width=string_size.x+padding+20.0
		if total_width>max_width:
			max_width=total_width
		item.custom_minimum_size.x=max_width
		var line_height=item.name_file_item_node.get_line_height()
		var text_len=item.name_file_item_node.text.length()
		var estimated_lines=max(1,ceil(text_len/128.0))
		var padding_y=item.name_file_item_node.get_theme_constant("text_padding") * 2
		var total_height=(estimated_lines*line_height)+padding_y+16
		item.custom_minimum_size.y=total_height
