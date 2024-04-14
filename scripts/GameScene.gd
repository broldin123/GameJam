extends Node2D

var timeUntilNextDogPoop = 4
var questPrefab = load("res://scenes/progress_meter.tscn")

var isWorkPlayer = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting game scene")
	global.wifeChatFinished = false
	$Scale/Control/WifeChat/btnBeginDay.visible = false
	$Scale/Control/WifeChat.visible = true
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/introWifeChat.dialogue"))
	$Scale/ScalePlateRight/House/Skeledog/animSkeleDog.play("skeleDog walk cycle")
	global.animatedScale = $Scale/animScaleUpDown
	global.OnSceneLoaded("GameScene")

func _on_btn_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/TitleScene.tscn")

func _on_btn_start_home_pressed():
	global.animatedScale.play("RightDownToUp")

func _on_btn_start_work_pressed():
	global.animatedScale.play("RightUpToDown")
	
func _on_btn_end_screen_pressed():
	get_tree().change_scene_to_file("res://scenes/EndScene.tscn")

func _input(_event):
	if Input.is_action_just_pressed("toggleDebugButtons"):
		$Scale/Control/DebugButtons.visible = !$Scale/Control/DebugButtons.visible

#hides the wife chat when we push the begin day button
func _on_btn_begin_day_pressed():
	$Scale/Control/WifeChat.visible = false
	global.animatedScale.play("RightDownToUp")
	
func trySpawnDogPoop():
	if( timeUntilNextDogPoop > 0):
		return
	timeUntilNextDogPoop = randf_range(7, 20)
	var newProgressMeter = questPrefab.instantiate()
	print("poop %s spawned!" % global.poopNum)
	newProgressMeter._setup("Clean Poop %s" % global.poopNum, 2, 10)
	global.poopNum += 1
	$Scale/ScalePlateRight/House/Skeledog.get_parent().add_child(newProgressMeter)
	newProgressMeter.global_position = $Scale/ScalePlateRight/House/Skeledog.global_position

func updateHealthDisplay():
	#$Scale/ScalePlateLeft/txtHealth.text = "[center]Health: %s / %s[/center]" % global.playerCurHealth % global.playerMaxHealth
	return

#shows the button after we finish the wife chat
#called every frame
func _process(delta):
	timeUntilNextDogPoop -= delta
	updateHealthDisplay()
	trySpawnDogPoop()
	if global.wifeChatFinished:
		$Scale/Control/WifeChat/btnBeginDay.visible = true
