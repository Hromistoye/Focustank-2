extends Control
@onready var tex_wallpaper_node:TextureRect=$tex_wallpaper

const DEFAULT_WALLPAPER_PATH:String="res://assets/wallpaper.png"
const WALLPAPER_DIR:String="user://.outside/wallpapers/"
const MARKED_WALLPAPER_NAME:String="marked_wallpaper.png"
const MARKED_WALLPAPER_PATH:String=WALLPAPER_DIR+MARKED_WALLPAPER_NAME

var wallpaper_changable_paths:Array[String]=[]
var last_wallpaper_changable_paths:Array[String]=[]
var current_wallpaper_path:String=""
var current_wallpaper_index:int=-1

func _ready() -> void:
	init_wallpaper()
	check_current_wallpapers()
	update_current_wallpaper_index()
	pass
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:#在存在可用壁纸文件时实现切换壁纸操作
	#↓ 标记壁纸
	#← 上一张-刷新可用壁纸文件，更新索引
	#→ 下一张-刷新可用壁纸文件，更新索引
	#用当前索引找到壁纸文件并实际替换
	if wallpaper_changable_paths.is_empty():
		return
	if event.is_action_pressed("ui_down"):
		if current_wallpaper_path.is_empty():
			return 
		var copy_error=DirAccess.copy_absolute(current_wallpaper_path,MARKED_WALLPAPER_PATH)
	if event.is_action_pressed("ui_left"):
		check_current_wallpapers()
		update_current_wallpaper_index()
		current_wallpaper_index=(current_wallpaper_index-1)%wallpaper_changable_paths.size()
	elif event.is_action_pressed("ui_right"):
		check_current_wallpapers()
		update_current_wallpaper_index()
		current_wallpaper_index=(current_wallpaper_index+1)%wallpaper_changable_paths.size()
	current_wallpaper_path=wallpaper_changable_paths[current_wallpaper_index]
	var texture=load_wallpaper_tex_from_path(wallpaper_changable_paths[current_wallpaper_index])
	if texture:
		tex_wallpaper_node.texture=texture

func init_wallpaper():#壁纸初始化
	#加载被标记的壁纸；
	#如果没有被标记的壁纸，加载用户壁纸目录下的首张可加载文件；
	#如果从用户壁纸目录寻找可用文件失败，加载资源文件夹默认壁纸	
	var dir=DirAccess.open(WALLPAPER_DIR)
	var texture:Texture2D=null
	if FileAccess.file_exists(MARKED_WALLPAPER_PATH):
		var image=Image.load_from_file(MARKED_WALLPAPER_PATH)
		if image:
			texture=ImageTexture.create_from_image(image)
			current_wallpaper_path=MARKED_WALLPAPER_PATH
	else:
		dir.list_dir_begin()
		var file_name=dir.get_next()
		while file_name!="":
			if not dir.current_is_dir() and is_image_file(file_name):
				var file_path=WALLPAPER_DIR+file_name
				var image=Image.load_from_file(file_path)
				if image:
					texture=ImageTexture.create_from_image(image)
					current_wallpaper_path=file_path
				break
		dir.list_dir_end()
	if texture==null:
		texture=ResourceLoader.load(DEFAULT_WALLPAPER_PATH,"Texture2D",ResourceLoader.CACHE_MODE_REUSE)
		current_wallpaper_path=DEFAULT_WALLPAPER_PATH
	tex_wallpaper_node.texture=texture
func update_current_wallpaper_index():#自动寻找当前索引
	#-1 无可用壁纸的异常索引值
	if wallpaper_changable_paths.is_empty() or current_wallpaper_path=="":
		current_wallpaper_index=-1
		return
	var index=wallpaper_changable_paths.find(current_wallpaper_path)
	if index!=-1:
		current_wallpaper_index=index
	else:
		current_wallpaper_index=-1
func check_current_wallpapers():#刷新当前可用壁纸列表
	#清理当前可用壁纸列表
	#打开目录并依次添加图像类文件
	wallpaper_changable_paths.clear()
	var dir
	var file_name
	dir=DirAccess.open(WALLPAPER_DIR)
	if not dir:
		return
	dir.list_dir_begin()
	file_name=dir.get_next()
	while file_name!="":
		if not dir.current_is_dir() and is_image_file(file_name):
			var file_path=WALLPAPER_DIR+file_name
			wallpaper_changable_paths.append(file_path)
		file_name=dir.get_next()
	wallpaper_changable_paths.sort()
	dir.list_dir_end()
	if not wallpaper_changable_paths.is_empty()&&wallpaper_changable_paths==last_wallpaper_changable_paths:
		return
	last_wallpaper_changable_paths=wallpaper_changable_paths.duplicate()
func load_wallpaper_tex_from_path(path:String)->Texture2D:#用可用文件路径转换image资源
	var image=Image.load_from_file(path)
	if image:
		return ImageTexture.create_from_image(image)
	return null
func is_image_file(file_name)->bool:#判断是否是图像文件
	var extension=file_name.get_extension().to_lower().trim_prefix(".")
	return extension in ["png","jpg","jpeg","bmp","webp","tga","svg"]
