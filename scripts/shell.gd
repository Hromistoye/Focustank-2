extends Node2D
#fake .bash_profile
var ol_dirs=["user://.inside/l_hand","user://.inside/r_hand",
"user://.inside/body/stomach","user://.inside/body/heart",
"user://.inside/head/brain",
"user://.outside/wallpapers",
]


func _ready() -> void:
	load_fake_bash_profile()
	pass
func _process(delta: float) -> void:
	pass
func load_fake_bash_profile():
	var fuzztank_dir=DirAccess.open("user://")
	var sp_dirs=["user://.inside","user://.outside"]
	if not fuzztank_dir:
		return
	for ol_dir in ol_dirs:
		if not DirAccess.dir_exists_absolute(ol_dir):
			DirAccess.make_dir_recursive_absolute(ol_dir)
	for sp_dir in sp_dirs:
		if DirAccess.dir_exists_absolute(sp_dir):
			FileAccess.set_hidden_attribute(sp_dir,true)
			
	pass
