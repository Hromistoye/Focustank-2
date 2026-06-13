extends HFlowContainer
const FILE_ITEM_SCENE=preload("res://scenes/file_item_FileSystemApp.tscn")#文件视图单个文件项的数据结构
var current_files_will_draw:Array=[]
var current_path:String="user://"
var last_current_path:String="user://"
var last_path:String="user://"

func _ready() -> void:
	init_current_ui_tree()
	pass
func _process(delta: float) -> void:
	scan_current_ui_tree()
	if last_current_path!=current_path:
		draw_current_ui_tree()
	pass
func init_current_ui_tree():#扫描，更新文件名数组；绘制文件视图
	scan_current_ui_tree()
	draw_current_ui_tree()
func scan_current_ui_tree():
	#清空旧数据;
	#创建目录类，尝试得到可检索路径
	#将目录中的每个文件项信息依照特定的数据结构存储
	last_current_path=current_path
	current_files_will_draw.clear()
	var current_dir=DirAccess.open(current_path)
	if not current_dir:
		return
	current_path=current_dir.get_current_dir()
	current_dir.include_hidden=true
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
	#清空容器内的文件项
	#依照模板创建结构并初始化
	#将文件项依次装入
	#链接文件项的行为响应信号
	for child in get_children():
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
		
func _on_file_item_file_system_app_gui_input(event: InputEvent,the_item) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.double_click:
			var file_item=the_item
			if file_item.file_type=="folder":
				var new_path=current_path.path_join(file_item.file_name)
				var new_dir=DirAccess.open(new_path)
				if not new_dir:
					return
				last_path=current_path
				current_path=new_path
				print(last_path)
				print(current_path)
				scan_current_ui_tree()
				draw_current_ui_tree()
	pass 
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_RIGHT:
			current_files_will_draw.clear()
			var last_dir=DirAccess.open(last_path)
			if not last_dir:
				return
			current_path=last_path
			last_dir.include_hidden=true
			last_dir.list_dir_begin()
			var file_name=last_dir.get_next()
			while file_name!="":
				var file_path=current_path.path_join(file_name)
				var is_directory=last_dir.current_is_dir()
				current_files_will_draw.append({
					"name":file_name,
					"path":file_path,
					"is_dir":is_directory
				})
				file_name=last_dir.get_next()
			last_dir.list_dir_end()
			draw_current_ui_tree()
	pass 
