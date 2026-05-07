extends Control
var current_dir_path:String=""
var current_dir_content:Array=[]
func _ready() -> void:
	#先扫描目录，更新环境记录
	var user_dir=DirAccess.open("user://")
	if not user_dir:
		return
	user_dir.include_hidden = true
	user_dir.list_dir_begin()	
	var file_name=user_dir.get_next()
	while file_name!="":
		print("hello")
		current_dir_content.append(file_name)
		file_name=user_dir.get_next()
	print(current_dir_content)
	user_dir.list_dir_end()
func _process(delta: float) -> void:
	pass
	
	
