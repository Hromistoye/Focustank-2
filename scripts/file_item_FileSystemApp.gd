#文件系统单个文件项的数据结构
extends Control
@onready var icon_file_item_node:TextureRect=$icon_file_item
@onready var name_file_item_node:Label=$name_file_item
@onready var name_input_file_item_node:TextEdit=$name_input_file_item
@onready var popmenu_file_item:PopupMenu=$popmenu_file_item
var file_icon:Texture2D=null
var file_name:String=""
var file_path:String=""
var file_type:String=""
signal emit_file_item_act_index(file_item_act_index)
signal emit_file_item_new_name(new_name)
func _ready() -> void:
	apply_data()
	popmenu_item_init()
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
	popmenu_file_item.add_item("rename")
	popmenu_file_item.add_item("copy")
	popmenu_file_item.add_item("eat")
func _on_popmenu_file_item_index_pressed(index: int) -> void:
	emit_file_item_act_index.emit(index)
	pass 
func _on_name_file_item_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode==KEY_ENTER:
		name_input_file_item_node.accept_event()
		var new_name=name_input_file_item_node.text
		name_input_file_item_node.release_focus()
		name_input_file_item_node.hide()
		name_file_item_node.show()
		name_file_item_node.text=new_name
		emit_file_item_new_name.emit(new_name)
	pass # Replace with function body.
