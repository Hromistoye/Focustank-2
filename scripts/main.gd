extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pe_t_goodbye() -> void:
	get_tree().quit()
	pass 


func _on_pe_t_hunger() -> void:
	pass # Replace with function body.
