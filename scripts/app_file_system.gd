extends Control
const FILE_ITEM_SCENE=preload("res://scenes/file_item_app_file_system.tscn")
var current_files_will_draw:Array=[]
var current_path:String=""
@onready var container_files_node:HFlowContainer=$container_files
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_current_ui_tree()
	pass # Replace with function body.
func _process(delta: float) -> void:
	pass
func init_current_ui_tree():
	scan_current_ui_tree()
	draw_current_ui_tree()
func scan_current_ui_tree():
	current_files_will_draw.clear()
	if not current_path:
		current_path="user://"
	var current_dir=DirAccess.open(current_path)
	if current_dir==null:
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
	for child in container_files_node.get_children():
		child.queue_free()
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
		file_item.find_child("icon_file_item").gui_input.connect(_on_icon_file_item_gui_input.bind(file_item))
func _on_icon_file_item_gui_input(event: InputEvent,the_item:Node) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.double_click:
			var file_item=the_item
			if file_item.file_type=="folder":
				var new_path=current_path.path_join(file_item.file_name)
				var new_dir=DirAccess.open(new_path)
				if not new_dir:
					return
				current_path=new_path
				scan_current_ui_tree()
				draw_current_ui_tree()
	pass
