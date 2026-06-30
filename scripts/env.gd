extends Node
const SCREEN_TOP=16 *2 
const SCREEN_BOTTOM=112 *2
const SCREEN_LEFT=32 *2
const SCREEN_RIGHT=176 *2

const ICON_SIZE=16

var physic_status={
	"hunger":100,
	"storage_servings":0,
	"mana":0,
	"feeling":"calm",
	"vocalization":"嗯......",
	"time_stamp":null,
	}

signal open_a_folder()
func _ready() -> void:
	pass 
func _process(delta: float) -> void:
	pass
