extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(Env.physic_status.hunger)
	pass


func _on_pe_t_goodbye() -> void:
	get_tree().quit()
	pass 
