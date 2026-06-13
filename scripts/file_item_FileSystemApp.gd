#文件系统单个文件项的数据结构
extends Control
var file_icon:Texture2D=null
var file_name:String=""
var file_path:String=""
var file_type:String=""
@onready var icon_file_item_node:TextureRect=$icon_file_item
@onready var name_file_item_node:Label=$name_file_item
@onready var popmenu_file_item:PopupMenu=$popmenu_file_item
func _ready() -> void:
	apply_data()
	pass 
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
	icon_file_item_node.texture=file_icon
	name_file_item_node.text=file_name
func popmenu_item_init():
	popmenu_file_item.add_item("eat")
