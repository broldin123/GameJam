extends Node2D


func _on_btn_play_pressed():
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")


func _on_btn_quit_pressed():
	get_tree().quit()
