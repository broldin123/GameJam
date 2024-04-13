extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Info.visible = false
	$Control/MainMenu.visible = true
	
	

func _on_btn_play_pressed():
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")


func _on_btn_quit_pressed():
	get_tree().quit()


func _on_btn_back_pressed():
	$Control/Info.visible = false
	$Control/MainMenu.visible = true

func _on_btn_how_to_play_pressed():
	$Control/Info.visible = true
	$Control/MainMenu.visible = false
