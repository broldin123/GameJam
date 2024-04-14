extends Node2D

var timeUntilNextDogPoop = 4
var questPrefab = load("res://scenes/progress_meter.tscn")

var isWorkPlayer = false

#TODO: The game needs to have an endstate - maybe after 3 minutes that triggers the conversation with the wife and the report card
#TODO: Kids running around house? Maybe one other errand besides dog?

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting game scene")
	global.wifeChatFinished = false
	$Scale/Control/WifeChat/btnBeginDay.visible = false
	$Scale/Control/WifeChat.visible = true
	global.StartDialogue("wife-start")
	$Scale/ScalePlateRight/House/Skeledog/animSkeleDog.play("skeleDog walk cycle")
	$Scale/ScalePlateRight/House/Skelekid/animSkeleKid.play("skeleKid walk cycle")
	$Scale/ScalePlateRight/House/Skelekid2/animSkeleKid2.play("skeleKid 2 walk cycle")
	global.animatedScale = $Scale/animScaleUpDown
	global.OnSceneLoaded("GameScene")
	global.playerHealthDisplay = $Scale/txtYourHealth
	global.portalToHome = $Scale/ScalePlateLeft/PortalToHome

func _on_btn_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/TitleScene.tscn")

func _on_btn_start_home_pressed():
	global.animatedScale.play("RightDownToUp")

func _on_btn_start_work_pressed():
	global.animatedScale.play("RightUpToDown")
	$workMusic.play()
	
func _on_btn_end_screen_pressed():
	get_tree().change_scene_to_file("res://scenes/EndScene.tscn")

func _input(_event):
	if Input.is_action_just_pressed("toggleDebugButtons"):
		$Scale/Control/DebugButtons.visible = !$Scale/Control/DebugButtons.visible

#hides the wife chat when we push the begin day button
func _on_btn_begin_day_pressed():
	global.gameTimeLeft = global.gameDuration
	$Scale/Control/WifeChat.visible = false
	global.animatedScale.play("RightDownToUp")
	
	
func trySpawnDogPoop():
	if( timeUntilNextDogPoop > 0):
		return
	timeUntilNextDogPoop = randf_range(7, 20)
	var newProgressMeter = questPrefab.instantiate()
	print("poop %s spawned!" % global.poopNum)
	$Poop.play()
	newProgressMeter._setup("Clean Poop #%s" % global.poopNum, 2, 10)
	global.poopNum += 1
	$Scale/ScalePlateRight/House/Skeledog.get_parent().add_child(newProgressMeter)
	newProgressMeter.global_position = $Scale/ScalePlateRight/House/Skeledog.global_position

func updateHealthDisplay():
	#$Scale/ScalePlateLeft/txtHealth.text = "[center]Health: %s / %s[/center]" % global.playerCurHealth % global.playerMaxHealth
	return

#shows the button after we finish the wife chat
#called every frame
func _process(delta):
	if global.wifeChatFinished:
		$Scale/Control/WifeChat/btnBeginDay.visible = true

	if global.playerSurvivedConvoNeeded:
		global.playerSurvivedConvoNeeded = false
		global.StartDialogue("wife-end-survived")
		$Scale/Control/WifeChat.visible = true
		$Scale/Control/WifeChat/btnBeginDay.visible = false
		return
	
	if global.playerDiedConvoNeeded:
		global.playerDiedConvoNeeded = false
		global.StartDialogue("wife-end-dead")
		$Scale/Control/WifeChat.visible = true
		$Scale/Control/WifeChat/btnBeginDay.visible = false
		return
	
	if global.gameTimeLeft <= 0:
		return	
	
	var oldGameTime = global.gameTimeLeft
	global.gameTimeLeft -= delta
	#print("oldGameTime: ", oldGameTime, " NewGameTime: ", global.gameTimeLeft)
	
	$Scale/txtTimeUntilEndOfDay.text = "[center]Time until end of day: %ss[/center]" % int(global.gameTimeLeft)
	if global.gameTimeLeft < 0:
		#print("GameTimeExpired: ", global.gameTimeLeft)
		global.gameTimeLeft = 0
		global.EndGame("timeFinished")
	
	timeUntilNextDogPoop -= delta
	updateHealthDisplay()
	trySpawnDogPoop()
		
	
