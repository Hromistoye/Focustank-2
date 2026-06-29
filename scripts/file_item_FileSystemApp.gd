#文件系统单个文件项的数据结构
extends Control
@onready var icon_file_item_node:TextureRect=$icon_file_item
@onready var name_file_item_node:Label=$name_file_item
@onready var name_input_file_item_node:TextEdit=$name_input_file_item
@onready var popmenu_file_item:PopupMenu=$popmenu_file_item
var file_name:String=""
var file_path:String=""
var file_type:String=""
var file_icon:Texture2D=null
signal emit_file_item_act_index(file_item_act_index)
signal emit_file_item_new_name(new_name)
signal emit_file_item_moved_path(unmoved_path,moved_path)
func _ready() -> void:
	apply_data()
	popmenu_item_init()
	name_file_item_node.set_drag_forwarding(
		Callable(self,"_get_drag_data"),
		Callable(self,"_can_drop_data"),
		Callable(self,"_drop_data")
	)
	pass
func _process(delta: float) -> void:
	pass
func _on_icon_file_item_gui_input(event: InputEvent) -> void:
	pass
func apply_data() -> void:
	icon_file_item_node.texture=file_icon
	name_file_item_node.text=file_name
func popmenu_item_init():
	popmenu_file_item.add_item("rename")
	popmenu_file_item.add_item("copy")
	popmenu_file_item.add_item("eat")
func _on_name_input_file_item_focus_entered() -> void:
	name_input_file_item_node.text=file_name
	pass
func setup(p_name: String, p_path: String, p_type: String, p_icon: Texture2D) -> void:
	file_name=p_name
	file_path=p_path
	file_type=p_type
	file_icon=p_icon
	if is_node_ready():
		apply_data()
func _on_popmenu_file_item_index_pressed(index: int) -> void:
	emit_file_item_act_index.emit(index)
	pass
func _on_name_file_item_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode==KEY_ENTER:
		name_input_file_item_node.accept_event()
		var new_name=name_input_file_item_node.text
		if name_input_file_item_node.text!=file_name:
			name_file_item_node.text=new_name
			emit_file_item_new_name.emit(new_name)
		name_input_file_item_node.release_focus()
		name_input_file_item_node.hide()
		name_file_item_node.show()
	pass # Replace with function body.
func _get_drag_data(at_position: Vector2) -> Variant:
	var info_dic={"name":file_name,
	"path":file_path,
	"icon":file_icon,
	"type":file_type,}
	var preview=TextureRect.new()
	if info_dic.type!="folder":
		preview.texture=preload("res://assets/icon1.png")
	else:
		preview.texture=preload("res://assets/icon2.png")
	preview.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	preview.size=Vector2(16,16)
	set_drag_preview(preview)
	return info_dic
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if file_type=="folder":
		return true
	else:
		return false
func _drop_data(at_position: Vector2, data: Variant) -> void:
	print("here!")
	var undropped_path=data["path"]
	var dropped_path=file_path.path_join(data["name"])
	emit_file_item_moved_path.emit(undropped_path,dropped_path)
	
