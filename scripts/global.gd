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

var testA = "123"
var homePlayer = null
var workPlayer = null
var animatedScale = null

var adventurer = null
var adventureProgress = null

var playerCurHealth = 100
var playerMaxHealth = 100

var questPrefab = load("res://scenes/progress_meter.tscn")

func OnSceneLoaded(sceneName):
	testA = "456"
	if( sceneName == "GameScene"):
		SetPlayer(false)

# Tick function
func _process(_delta):
	if Input.is_action_just_pressed("toggleWorkHome"):
		SetPlayer(!isWorkActive)
	if Input.is_action_just_pressed("wifeStartConvo"):
		StartDialogue("wife-start")
	if Input.is_action_just_pressed("adventurerStartConvo"):
		StartDialogue("adventurer-start")
	if Input.is_action_just_pressed("wifeEndConvo"):
		StartDialogue("wife-end")
	
func StartDialogue(dialogueName):
	if dialogueName == "wife-start":
		DialogueManager.show_example_dialogue_balloon(load("res://dialogues/introWifeChat.dialogue"))
	elif dialogueName == "adventurer-start":
		DialogueManager.show_example_dialogue_balloon(load("res://dialogues/introAdventurerChat.dialogue"))
	elif dialogueName == "wife-end":
		DialogueManager.show_example_dialogue_balloon(load("res://dialogues/exitWifeChat.dialogue"))
	else:
		print("unknown dialogue requested: ", dialogueName)
	
func SetPlayer(isWork):
	assert(homePlayer != null, "homePlayer is null.")
	assert(workPlayer != null, "workPlayer is null.")
	isWorkActive = isWork
	workPlayer.set_process(isWorkActive)
	workPlayer.visible = isWorkActive
	homePlayer.set_process(!isWorkActive)
	homePlayer.visible = !isWorkActive
	if isWorkActive:
		animatedScale.play("RightUpToDown")
	else:
		animatedScale.play("RightDownToUp")
		
	if isWorkActive:	
		adventureProgress = questPrefab.instantiate()
		var timeLimit = 30 - (adventurerNum * 5);
		if( timeLimit < 10):
			timeLimit = timeLimit
		
		adventureProgress._setup("Defeat Adventurer #%s" % adventurerNum, -1, timeLimit)
		adventurerNum += 1
		adventurer.add_child(adventureProgress)
		adventureProgress.global_position = adventurer.global_position
		adventureProgress.global_position += Vector2(0, -220)
	
