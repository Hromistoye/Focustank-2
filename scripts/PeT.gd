extends Node2D
const PHYSIC_STATUS_PATH="user://.outside/physic_status/PeT_status.json"
const FEELING_SORT=[
"calm",
"annoyed",
"down",
"happy",
"confused"]
@onready var timer_status_node=$timer_status
func _ready() -> void:
	physic_status_load()
	timer_status_node_init()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func timer_status_node_init():
	timer_status_node.wait_time=1.0
	timer_status_node.start()
	
func physic_status_init():#初始化结构
	var status_str=JSON.stringify(Env.physic_status,"\t")
	var status_file=FileAccess.open(PHYSIC_STATUS_PATH,FileAccess.WRITE)
	status_file.store_string(status_str)
	status_file.close()
func physic_status_load():#读取可用状态
	#如果没有可用记录,初始化记录
	#依次读取数据
	if not FileAccess.file_exists(PHYSIC_STATUS_PATH):
		physic_status_init()
	else:
		var status_file=FileAccess.open(PHYSIC_STATUS_PATH,FileAccess.READ)
		var status_str=status_file.get_as_text()
		status_file.close()
		var status_json=JSON.parse_string(status_str)
		if status_json!=null:
			if status_json.has("hunger"):
				Env.physic_status["hunger"]=status_json["hunger"]
			if status_json.has("mana"):
				Env.physic_status["mana"]=status_json["mana"]
			if status_json.has("feeling"):
				Env.physic_status["feeling"]=status_json["feeling"]
			if status_json.has("vocalization"):
				Env.physic_status["vocalization"]=status_json["vocalization"]
			if status_json.has("time_stamp"):
				Env.physic_status["time_stamp"]=status_json["time_stamp"]
		pass


func _on_timer_status_timeout() -> void:#饥饿值的流逝
	Env.physic_status["hunger"]-=0.01
	print("-0.01!")
	print(Env.physic_status["hunger"])
	pass 

func mana():
	pass
