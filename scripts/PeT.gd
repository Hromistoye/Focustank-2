extends Node2D
const PHYSIC_STATUS_PATH="user://.outside/physic_status/PeT_status.json"
const FEELING_SORT=[
"calm",
"annoyed",
"down",
"happy",
"confused"]
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
