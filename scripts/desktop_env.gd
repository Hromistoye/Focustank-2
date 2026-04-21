extends Node2D
@onready var tex_wallpaper_node:Sprite2D=$tex_wallpaper

const DEFAULT_WALLPAPER_PATH="res://assets/wallpaper.png"
const WALLPAPER_DIR="user://.outside/wallpapers/"
const WALLPAPER_NAME="marked_wallpaper.png"
const MARKED_WALLPAPER_PATH:String=WALLPAPER_DIR+WALLPAPER_NAME

var wallpaper_changable_paths:Array[String]=[]
var current_wallpaper_index:int=-1
var last_folder_mod_time:int=0
var current_wallpaper_path: String = ""#
func _ready() -> void:
	init_wallpaper()
	check_current_wallpapers()
	update_current_wallpaper_index()
	pass
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:#更新索引
	check_current_wallpapers()
	update_current_wallpaper_index()	
	if not (event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right")):
		return
	if wallpaper_changable_paths.is_empty():
		return
	if event.is_action_pressed("ui_left"):
		current_wallpaper_index=(current_wallpaper_index-1)%wallpaper_changable_paths.size()
	elif event.is_action_pressed("ui_right"):
		current_wallpaper_index=(current_wallpaper_index+1)%wallpaper_changable_paths.size()
		
	current_wallpaper_path = wallpaper_changable_paths[current_wallpaper_index]#
	var texture=load_wallpaper_tex_from_path(wallpaper_changable_paths[current_wallpaper_index])
	if texture:
		tex_wallpaper_node.texture=texture
func load_wallpaper_tex_from_path(path:String)->Texture2D:
	var image=Image.load_from_file(path)
	if image:
		return ImageTexture.create_from_image(image)
	return null
func init_wallpaper():
	var texture:Texture2D=null
	var dir=DirAccess.open(WALLPAPER_DIR)
	var loaded_path: String = ""#
	
	if FileAccess.file_exists(MARKED_WALLPAPER_PATH):
		var image=Image.load_from_file(MARKED_WALLPAPER_PATH)
		if image:
			texture=ImageTexture.create_from_image(image)
	else:
		dir.list_dir_begin()
		var file_name=dir.get_next()
		while file_name!="":
			if not dir.current_is_dir() and is_image_file(file_name):
				var file_path=WALLPAPER_DIR+file_name
				var image=Image.load_from_file(file_path)
				if image:
					texture=ImageTexture.create_from_image(image)
				break
		dir.list_dir_end()
	if texture==null:
		texture=ResourceLoader.load(DEFAULT_WALLPAPER_PATH,"Texture2D",ResourceLoader.CACHE_MODE_REUSE)
		loaded_path = DEFAULT_WALLPAPER_PATH   # 
	tex_wallpaper_node.texture=texture
	current_wallpaper_path = loaded_path #
func is_image_file(file_name)->bool:
	var extension=file_name.get_extension().to_lower().trim_prefix(".")
	return extension in ["png","jpg","jpeg","bmp","webp","tga","svg"]

func update_current_wallpaper_index():
	if wallpaper_changable_paths.is_empty() or current_wallpaper_path == "":
		current_wallpaper_index = -1
		return
	var idx = wallpaper_changable_paths.find(current_wallpaper_path)
	if idx != -1:
		current_wallpaper_index = idx
	else:
		current_wallpaper_index = -1
func get_folder_mod_time()->int:
	var dir=DirAccess.open(WALLPAPER_DIR)
	if dir:
		var files=dir.get_files()
		if not files.is_empty():
			return FileAccess.get_modified_time(WALLPAPER_DIR+files[0])
		else:
			return Time.get_unix_time_from_system()
	return 0
func check_current_wallpapers():
	var current_mod=get_folder_mod_time()
	if current_mod==last_folder_mod_time and not wallpaper_changable_paths.is_empty():
		return
	last_folder_mod_time=current_mod
	wallpaper_changable_paths.clear()
	var file_name
	var dir
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
