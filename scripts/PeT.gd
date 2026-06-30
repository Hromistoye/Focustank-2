extends Node2D
const PHYSIC_STATUS_PATH="user://.outside/physic_status/PeT_status.json"
const FEELING_SORT=[
"calm",
"annoyed",
"down",
"happy",
"confused"]
const EXTENSION_CATEGORY:Dictionary={
	#纯ASCII文件
	"txt": "text",
	"log": "text",
	"md": "text",
	"rtf": "text",
	"csv": "text",
	"tsv": "text",
	"json": "text",
	"xml": "text",
	"yaml": "text",
	"yml": "text",
	"toml": "text",
	"ini": "text",
	"cfg": "text",
	"conf": "text",
	"html": "text",
	"htm": "text",
	"css": "text",
	"scss": "text",
	"sass": "text",
	"sql": "text",
	#图像
	"png": "image",
	"jpg": "image",
	"jpeg": "image",
	"gif": "image",
	"bmp": "image",
	"tif": "image",
	"tiff": "image",
	"webp": "image",
	"svg": "image",
	"ico": "image",
	"heic": "image",
	"heif": "image",
	"raw": "image",
	"psd": "image",
	"ai": "image",
	"eps": "image",
	#音频
	"mp3": "audio",
	"wav": "audio",
	"flac": "audio",
	"aac": "audio",
	"ogg": "audio",
	"m4a": "audio",
	"wma": "audio",
	"aiff": "audio",
	"aif": "audio",
	"mid": "audio",
	"midi": "audio",
	#视频
	"mp4": "video",
	"avi": "video",
	"mkv": "video",
	"mov": "video",
	"wmv": "video",
	"flv": "video",
	"webm": "video",
	"m4v": "video",
	"3gp": "video",
	"mpeg": "video",
	"mpg": "video",
	#3D模型
	"fbx": "model_3d",
	"obj": "model_3d",
	"gltf": "model_3d",
	"glb": "model_3d",
	"stl": "model_3d",
	"3mf": "model_3d",
	"usdz": "model_3d",
	"usd": "model_3d",
	"blend": "model_3d",
	"3ds": "model_3d",
	"dae": "model_3d",
	"ply": "model_3d",
	"step": "model_3d",
	"stp": "model_3d",
	"iges": "model_3d",
	"igs": "model_3d",
	"dxf": "model_3d",
	"dwg": "model_3d",
	#l2d模型
	"l2d": "model_l2d",
	"moc3": "model_l2d",
	"moc": "model_l2d",
	#压缩包
	"zip": "archive",
	"rar": "archive",
	"7z": "archive",
	"tar": "archive",
	"gz": "archive",
	"bz2": "archive",
	"xz": "archive",
	"cab": "archive",
	"arj": "archive",
	"lzh": "archive",
	"tgz": "archive",
	#编程源代码
	"py": "code",
	"java": "code",
	"c": "code",
	"cpp": "code",
	"h": "code",
	"hpp": "code",
	"cs": "code",
	"go": "code",
	"rs": "code",
	"js": "code",
	"ts": "code",
	"php": "code",
	"rb": "code",
	"swift": "code",
	"kt": "code",
	"lua": "code",
	"gd": "code",
	"sh": "code",
	"bash": "code",
	"ps1": "code",
	"pl": "code",
	"r": "code",
	#数据
	"db": "data",
	"sqlite": "data",
	"dat": "data",
	"bin": "data",
	#可执行文件
	"exe": "executable",
	"msi": "executable",
	"dll": "executable",
	"so": "executable",
	"dylib": "executable",
	"app": "executable",
	"deb": "executable",
	"rpm": "executable",
	#字体
	"ttf": "font",
	"otf": "font",
	"woff": "font",
	"woff2": "font",
	#办公文档
	"doc": "document",
	"docx": "document",
	"xls": "document",
	"xlsx": "document",
	"ppt": "document",
	"pptx": "document",
	"pdf": "document",
	"odt": "document",
	"ods": "document",
	"odp": "document",
	"pages": "document",
	"key": "document",
	"wps": "document",
}
const KIB:int=1024
const MIB:int=1024*KIB
const POINTS_PER_REFERENCE_FILE:int=100
const MAX_POINTS_PER_FILE:int=600
const TYPE_THRESHOLD:int=50*100
const DISH_REFERENCE_SIZE:Dictionary={
	"text": 8*KIB,
	"image": 8*MIB,
	"audio": 10*MIB,
	"video": 1024*MIB,
	"model_3d": 1024*MIB,
	"model_l2d": 256*MIB,
	"archive": 64*MIB,
	"code": 16*KIB,
	"data": 8*MIB,
	"executable": 32*MIB,
	"font": 512*KIB,
	"document": 2*MIB,
	"dir": 0,
	"NOT_FOOD": 0,
}
@onready var timer_status_node=$timer_status

signal goodbye()
func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	physic_status_load()
	timer_status_node_init()
	pass
func _process(delta: float) -> void:
	pass

func _notification(what: int) -> void:
	if what==NOTIFICATION_WM_CLOSE_REQUEST:
		physic_status_save()
		goodbye.emit()
func physic_status_load():
	if not FileAccess.file_exists(PHYSIC_STATUS_PATH):
		physic_status_file_init()
	else:
		var status_file=FileAccess.open(PHYSIC_STATUS_PATH,FileAccess.READ)
		var status_str=status_file.get_as_text()
		status_file.close()
		var status_json=JSON.parse_string(status_str)
		if status_json!=null:
			if status_json.has("hunger"):
				Env.physic_status["hunger"]=status_json["hunger"]
			if status_json.has("storage_serving"):
				Env.physic_status["storage_serving"]=status_json["storage_serving"]
			if status_json.has("mana"):
				Env.physic_status["mana"]=status_json["mana"]
			if status_json.has("feeling"):
				Env.physic_status["feeling"]=status_json["feeling"]
			if status_json.has("vocalization"):
				Env.physic_status["vocalization"]=status_json["vocalization"]
			if status_json.has("time_stamp"):
				Env.physic_status["time_stamp"]=status_json["time_stamp"]
		pass
func physic_status_save():
	var status_str=JSON.stringify(Env.physic_status,"\t")
	var status_file=FileAccess.open(PHYSIC_STATUS_PATH,FileAccess.WRITE)
	status_file.store_string(status_str)
	status_file.close()
func physic_status_file_init():#初始化结构
	var status_str=JSON.stringify(Env.physic_status,"\t")
	var status_file=FileAccess.open(PHYSIC_STATUS_PATH,FileAccess.WRITE)
	status_file.store_string(status_str)
	status_file.close()
func timer_status_node_init():
	timer_status_node.wait_time=1.0
	timer_status_node.start()
func _on_timer_status_timeout() -> void:#饥饿值的流逝
	Env.physic_status["hunger"]-=0.01
	pass 
func mana():
	pass
func product_a_intermediate_file():
	var intermediate_file:Dictionary={
	"volume":0,
	"serving":0,
	"count":0,
	"first_bite_time_stamp":0,
	"type":null,
	}
	pass
func _on_container_files_cook(file_ext: Variant,isdir: bool, file_size: Variant) -> void:
	var dish_category:String=typeof_dish(str(file_ext))
	if isdir:
		dish_category="dir"
	var serving:int=sizeof_dish(dish_category,int(file_size))
	Env.physic_status.storage_servings+=serving
	while Env.physic_status.storage_servings>=TYPE_THRESHOLD:
		Env.physic_status.storage_servings-=TYPE_THRESHOLD
		print("我累计食用了50份额的文件。")
		#print("留空，这里到时候应该发送一个打印信号")
func sizeof_dish(dish_category:String,file_size:int)->int:
	if file_size<=0:
		return 0
	var reference_size:int=int(DISH_REFERENCE_SIZE.get(dish_category,0))
	if reference_size==0 and dish_category in ["dir","NOT_FOOD"]:
		if dish_category=="dir":
			reference_size=int(randfn(1,1024))*MIB
		else:
			reference_size=int(randfn(1,1024))*KIB
	var size_ratio:float=(float(file_size)/float(reference_size))
	var servings:int=roundi(
		float(POINTS_PER_REFERENCE_FILE)*log(1.0+size_ratio)/log(2.0))
	return clampi(servings,1,MAX_POINTS_PER_FILE)
func typeof_dish(ext:String):
	var normalized_ext:String=ext.strip_edges().to_lower()
	if normalized_ext.begins_with("."):
		normalized_ext=normalized_ext.substr(1)
	return str(
		EXTENSION_CATEGORY.get(
			normalized_ext,
			"NOT_FOOD"
		)
	)
