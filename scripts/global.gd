extends Node

var player_current_attack = false
var player_dodge = false
var questStatus_DontBurnTheOmlette = "None"
var questStatus_DefendTheCrypt = "None"
var wifeChatFinished = false

var isWorkActive = false

var questResults = [""]
var poopNum = 1

var testA = "123"
var homePlayer = null
var workPlayer = null
var animatedScale = null

var playerCurHealth = 100
var playerMaxHealth = 100

func OnSceneLoaded(sceneName):
	testA = "456"
	if( sceneName == "GameScene"):
		SetPlayer(false)

# Tick function
func _process(_delta):
	if Input.is_action_just_pressed("toggleWorkHome"):
		SetPlayer(!isWorkActive)
	
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
	
