extends Control
const TEX_FILE_ICON_PATH="res://assets/icon3.png"
const TEX_FOLDER_ICON_PATH="res://assets/icon4.png"
var file_icon:Texture2D=null
var file_name:String=""
var file_path:String=""
var file_type:String=""
@onready var icon_file_item_node:TextureRect = $icon_file_item
@onready var name_file_item_node:Label = $name_file_item
func _ready() -> void:
	apply_data()
	pass 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func setup(p_name: String, p_path: String, p_type: String, p_icon: Texture2D) -> void:
	file_name=p_name
	file_path=p_path
	file_type=p_type
	file_icon=p_icon
	if is_node_ready():
		apply_data()
func apply_data() -> void:
	icon_file_item_node.texture = file_icon
	name_file_item_node.text = file_name
