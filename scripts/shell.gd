extends Node2D
const ol_dirs=[
"user://.inside/l_hand","user://.inside/r_hand",
"user://.inside/body/stomach","user://.inside/body/rumen","user://.inside/body/heart",
"user://.inside/head/brain",
"user://.outside/wallpapers",
"user://.outside/physic_status",
]

func _ready() -> void:
	load_fake_bash_profile()
	pass
func _process(delta: float) -> void:
	pass

func load_fake_bash_profile():
	var fuzztank_dir=DirAccess.open("user://")
	if not fuzztank_dir:
		return
	for ol_dir in ol_dirs:
		if not DirAccess.dir_exists_absolute(ol_dir):
			DirAccess.make_dir_recursive_absolute(ol_dir)
	var hidden_dirs=["user://.inside","user://.outside"]
	for hidden_dir in hidden_dirs:
		if DirAccess.dir_exists_absolute(hidden_dir):
			FileAccess.set_hidden_attribute(hidden_dir,true)
	pass
