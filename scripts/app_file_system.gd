extends Control
const FILE_ITEM_SCENE=preload("res://scenes/file_item_app_file_system.tscn")
var current_files_will_draw:Array=[]
var current_path:String=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_current_ui_tree()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func init_current_ui_tree():
	scan_current_ui_tree()
	draw_current_ui_tree()
func scan_current_ui_tree():
	current_files_will_draw.clear()
	current_path="user://"
	var user_dir=DirAccess.open(current_path)
	if not user_dir:
		return
	user_dir.include_hidden=true
	user_dir.list_dir_begin()
	var file_name=user_dir.get_next()
	while file_name!="":
		var file_path=current_path.path_join(file_name)
		var is_directory=user_dir.current_is_dir()
		current_files_will_draw.append({
			"name":file_name,
			"path":file_path,
			"is_dir":is_directory
		})
		file_name=user_dir.get_next()
	user_dir.list_dir_end()
func draw_current_ui_tree():
	for file_info in current_files_will_draw:
		var file_item=FILE_ITEM_SCENE.instantiate()
		var icon:Texture2D
		var item_type:String
		if file_info["is_dir"]:
			item_type="folder"
			icon=preload("res://assets/icon4.png")
		else:
			item_type="file"
			icon=preload("res://assets/icon3.png")
		file_item.setup(
			file_info["name"],
			file_info["path"],
			item_type,
			icon
		)
		$container_files.add_child(file_item)
