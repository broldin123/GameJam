extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_btn_main_menu_pressed():
	get_tree().change_scene_to_file("res://TitleScene.tscn")

func _on_btn_start_home_pressed():
	$Scale/ScaleAnim.play("RightDownToUp")

func _on_btn_start_work_pressed():
	$Scale/ScaleAnim.play("RightUpToDown")
	
func _on_btn_end_screen_pressed():
	get_tree().change_scene_to_file("res://EndScene.tscn")
