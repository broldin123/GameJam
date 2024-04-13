extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/introWifeChat.dialogue"))
	$Scale/Control/WifeChat/btnBeginDay.visible = false

func _on_btn_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/TitleScene.tscn")

func _on_btn_start_home_pressed():
	$Scale/ScaleAnim.play("RightDownToUp")

func _on_btn_start_work_pressed():
	$Scale/ScaleAnim.play("RightUpToDown")
	
func _on_btn_end_screen_pressed():
	get_tree().change_scene_to_file("res://scenes/EndScene.tscn")

func _input(_event):
	if Input.is_action_just_pressed("toggleDebugButtons"):
		$Scale/Control/DebugButtons.visible = !$Scale/Control/DebugButtons.visible

#hides the wife chat when we push the begin day button
func _on_btn_begin_day_pressed():
	$Scale/Control/WifeChat.visible = false
	$Scale/ScaleAnim.play("RightDownToUp")
	
#shows the button after we finish the wife chat
#called every frame
func _process(_delta):
	if MyGlobals.wifeChatFinished:
		$Scale/Control/WifeChat/btnBeginDay.visible = true
