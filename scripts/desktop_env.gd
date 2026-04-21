extends Node2D
const DEFAULT_WALLPAPER_PATH="res://assets/wallpaper.png"
const WALLPAPER_DIR="user://.outside/wallpapers/"
const WALLPAPER_NAME="marked_wallpaper.png"
const MARKED_WALLPAPER_PATH:String=WALLPAPER_DIR+WALLPAPER_NAME
@onready var tex_wallpaper_node:Sprite2D=$tex_wallpaper
func _ready() -> void:
	init_wallpaper()
	pass 
func _process(delta: float) -> void:
	pass
func init_wallpaper():
	var texture:Texture2D=null
	var dir=DirAccess.open(WALLPAPER_DIR)
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
	tex_wallpaper_node.texture=texture
func is_image_file(file_name)->bool:
	var extension=file_name.get_extension().to_lower().trim_prefix(".")
	return extension in ["png","jpg","jpeg","bmp","webp","tga","svg"]
