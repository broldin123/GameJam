extends Node

var player_current_attack = false
var player_dodge = false
var questStatus_DontBurnTheOmlette = "None"
var questStatus_DefendTheCrypt = "None"
var wifeChatFinished = false

var isWorkActive = false

var questResults = [""]
var poopNum = 1
var adventurerNum = 1
var completedQuest = 0

var gameTimeLeft = -1
var gameDuration = 100

var testA = "123"
var homePlayer = null
var workPlayer = null
var animatedScale = null

var adventurer = null
var adventureProgress = null

var playerCurHealth = 100
var playerMaxHealth = 100

var questPrefab = load("res://scenes/progress_meter.tscn")
var playerHealthDisplay = null

var portalToHome = null

var playerDiedConvoNeeded = false
var playerSurvivedConvoNeeded = false

var adventurerNeedsRespawn = false

var shouldBringToEndScene = false

func SetPlayerHealthDisplay(newHealthPercent):
	playerHealthDisplay.text = "[center]Your Health: %s%%[/center]" % newHealthPercent

func ShowPortalToHome():
	portalToHome.visible = true
	return 

func OnSceneLoaded(sceneName):
	testA = "456"
	if( sceneName == "GameScene"):
		SetPlayer(false)


func PortalToHomeTaken():
	adventurerNeedsRespawn = true
	SetPlayer(false)

func EndGame(reason):
	if reason == "playerDied":
		playerDiedConvoNeeded = true
		return
	if reason == "timeFinished":
		playerSurvivedConvoNeeded = true
		return



# Tick function
func _process(_delta):
			
	if shouldBringToEndScene:
		shouldBringToEndScene = false
		get_tree().change_scene_to_file("res://scenes/EndScene.tscn")
		
	if Input.is_action_just_pressed("toggleWorkHome"):
		SetPlayer(!isWorkActive)
	if Input.is_action_just_pressed("wifeStartConvo"):
		StartDialogue("wife-start")
	if Input.is_action_just_pressed("adventurerStartConvo"):
		StartDialogue("adventurer-start")
	if Input.is_action_just_pressed("wifeEndConvo"):
		StartDialogue("wife-end-survived")
	
func StartDialogue(dialogueName):
	if dialogueName == "wife-start":
		DialogueManager.show_example_dialogue_balloon(load("res://dialogues/introWifeChat.dialogue"))
	elif dialogueName == "adventurer-start":
		DialogueManager.show_example_dialogue_balloon(load("res://dialogues/introAdventurerChat.dialogue"))
	elif dialogueName == "wife-end-survived":
		DialogueManager.show_example_dialogue_balloon(load("res://dialogues/exitWifeChat.dialogue"))
	elif dialogueName == "wife-end-dead":
		DialogueManager.show_example_dialogue_balloon(load("res://dialogues/exitWifeChatIfDead.dialogue"))
	else:
		print("unknown dialogue requested: ", dialogueName)
	
func SetPlayer(isWork):
	assert(homePlayer != null, "homePlayer is null.")
	assert(workPlayer != null, "workPlayer is null.")
	if portalToHome != null:
		portalToHome.visible = false
	isWorkActive = isWork
	workPlayer.set_process(isWorkActive)
	workPlayer.visible = isWorkActive
	homePlayer.set_process(!isWorkActive)
	homePlayer.visible = !isWorkActive
	if isWorkActive:
		animatedScale.play("RightUpToDown")
	else:
		#homelife mode - normal music
		animatedScale.play("RightDownToUp")
		
	if isWorkActive:	
		#Going to work - add epic fighting music
		adventureProgress = questPrefab.instantiate()
		var timeLimit = 30 - (adventurerNum * 5);
		if( timeLimit < 10):
			timeLimit = timeLimit
		adventureProgress._setup("Defeat Adventurer #%s" % adventurerNum, -1, timeLimit)
		adventurerNum += 1
		adventurer.add_child(adventureProgress)
		adventureProgress.global_position = adventurer.global_position
		adventureProgress.global_position += Vector2(0, -220)
	
