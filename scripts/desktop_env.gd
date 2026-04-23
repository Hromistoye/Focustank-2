extends Node2D
@onready var tex_wallpaper_node:Sprite2D=$tex_wallpaper
const DEFAULT_WALLPAPER_PATH:String="res://assets/wallpaper.png"
const WALLPAPER_DIR:String="user://.outside/wallpapers/"
const WALLPAPER_NAME:String="marked_wallpaper.png"
const MARKED_WALLPAPER_PATH:String=WALLPAPER_DIR+WALLPAPER_NAME
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
func _input(event: InputEvent) -> void:
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
	current_wallpaper_path=wallpaper_changable_paths[current_wallpaper_index]
	var texture=load_wallpaper_tex_from_path(wallpaper_changable_paths[current_wallpaper_index])
	if texture:
		tex_wallpaper_node.texture=texture
func load_wallpaper_tex_from_path(path:String)->Texture2D:
	var image=Image.load_from_file(path)
	if image:
		return ImageTexture.create_from_image(image)
	return null
func init_wallpaper():
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
func is_image_file(file_name)->bool:
	var extension=file_name.get_extension().to_lower().trim_prefix(".")
	return extension in ["png","jpg","jpeg","bmp","webp","tga","svg"]
func update_current_wallpaper_index():
	if wallpaper_changable_paths.is_empty() or current_wallpaper_path=="":
		current_wallpaper_index=-1
		return
	var index=wallpaper_changable_paths.find(current_wallpaper_path)
	if index!=-1:
		current_wallpaper_index=index
	else:
		current_wallpaper_index=-1
func check_current_wallpapers():
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
