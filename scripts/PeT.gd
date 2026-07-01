extends Node2D
const PHYSIC_STATUS_PATH="user://.outside/physic_status/PeT_status.json"
const VERY_HUNGER=30
const VOLUME_STOMACH=100*50
const SEC_PER_SERVING=600
const HUNGER_PER_SEC=0.005
const KIB:int=1024
const MIB:int=1024*KIB
const POINTS_PER_REFERENCE_FILE:int=100
const MAX_POINTS_PER_FILE:int=600
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
const FEELING_SORT=[
"calm",
"annoyed",
"down",
"happy",
"confused"]
@onready var timer_status_node=$timer_status
var current_time_stamp=null
signal hunger()
signal type()
signal goodbye()
func static_signal_connect():
	var application_FileSystem_scene=get_node("../../application_FileSystem")
	hunger.connect(application_FileSystem_scene._on_pe_t_hunger)
	pass
func _ready() -> void:
	_bootloader()
	static_signal_connect()
	pass
func _process(delta: float) -> void:
	pass
func _notification(what: int) -> void:
	if what==NOTIFICATION_WM_CLOSE_REQUEST:
		physic_status_save()
		goodbye.emit()

func _bootloader():
	if not FileAccess.file_exists(PHYSIC_STATUS_PATH):
		physic_status_file_init()
	else:
		physic_status_load()
	timer_status_node_init()
	what_happened()
func physic_status_load():
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
			Env.physic_status["time_stamp"]=Time.get_unix_time_from_system()
		pass
func physic_status_file_init():
	var status_str=JSON.stringify(Env.physic_status,"\t")
	var status_file=FileAccess.open(PHYSIC_STATUS_PATH,FileAccess.WRITE)
	status_file.store_string(status_str)
	status_file.close()
func what_happened():
	current_time_stamp=Time.get_unix_time_from_system()
	if current_time_stamp>=Env.physic_status["time_stamp"]:
		var passed_seconds=current_time_stamp-Env.physic_status["time_stamp"]
		var serving_to_mana=int(min(passed_seconds,Env.physic_status["storage_servings"])/SEC_PER_SERVING)
		Env.physic_status["hunger"]=max(Env.physic_status["hunger"]-passed_seconds*HUNGER_PER_SEC,0.0)
		Env.physic_status["mana"]+=serving_to_mana
		Env.physic_status["storage_servings"]-=serving_to_mana
		if Env.physic_status["hunger"]<=VERY_HUNGER:
			hunger_event()
		if Env.Env.physic_status["mana"]==100:
			type_event()
	Env.physic_status["time_stamp"]=current_time_stamp
	pass
func timer_status_node_init():
	timer_status_node.wait_time=1.0
	timer_status_node.start()
func _on_timer_status_timeout() -> void:#饥饿值的流逝
	Env.physic_status["hunger"]=max(Env.physic_status["hunger"]-HUNGER_PER_SEC,0.0)
	if Env.physic_status["hunger"]<=VERY_HUNGER:
		hunger_event()
	if Env.physic_status["storage_servings"]>0:
		Env.physic_status["mana"]+=1
		Env.physic_status["storage_servings"]-=1
		if Env.Env.physic_status["mana"]==100:#数值有问题，待会回来修一下
			type_event()
	pass 
func hunger_event():
	hunger.emit()
func type_event():
	type.emit()
	Env.physic_status["mana"]=0
func _on_container_files_cook(file_ext: Variant,isdir: bool, file_size: Variant) -> void:
	var dish_category:String=typeof_dish(str(file_ext))
	if isdir:
		dish_category="dir"
	var serving:int=sizeof_dish(dish_category,int(file_size))
	Env.physic_status.storage_servings+=serving
	if serving<=VOLUME_STOMACH:
		print("不需要这么多了！")
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
func physic_status_save():
	var status_str=JSON.stringify(Env.physic_status,"\t")
	var status_file=FileAccess.open(PHYSIC_STATUS_PATH,FileAccess.WRITE)
	status_file.store_string(status_str)
	status_file.close()
