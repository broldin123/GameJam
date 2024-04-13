extends Control

# counds down every tick
# when it reaches zero, the quest is failed
var timeUntilFailed = 3.0

# counts up when button is held
# when it reaches timeTotalProgressRequired, the quest is completed
var timeProgressed = 0.0

# Doesnt change, this is the total time required
var timeTotalProgressRequired = 0.0

# title of quest to show on meter and in end results screen
var questTitle = "Quest-Title"

var isActive = false

var allowProgress = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#_setup("Do it!", 3, 2)
	pass

func _setup(title_, progressTimeReq_, timeLimit_):
	questTitle = title_
	timeUntilFailed = timeLimit_
	timeProgressed = 0
	timeTotalProgressRequired = progressTimeReq_
	isActive = true
	$imgSuccess.visible = false
	$imgFail.visible = false
	$imgProgress.visible = true
	$imgProgressInRange.visible = false
	$txtTitle.text = "[center]%s[/center]" % title_
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( !isActive ):
		return
		
	if Input.is_action_pressed("progressQuest") && allowProgress:
		timeProgressed += delta
		
	timeUntilFailed -= delta
	if(timeUntilFailed < 0):
		timeUntilFailed = 0
	
	$txtTimeLeft.text = "[center]%ss[/center]" % int(timeUntilFailed)
	
	var curPercentProgress = int( (timeProgressed / timeTotalProgressRequired) * 100 )
	$txtProgress.text = "[center]%s%%[/center]" % curPercentProgress
	
	if(curPercentProgress > 100):
		isActive = false
		$txtTitle.text = ""
		$txtProgress.text = ""
		$txtTimeLeft.text = "[center]Completed: %s[/center]" % questTitle
		MyGlobals.questResults.append( "Completed: %s" % questTitle )
		$imgFail.visible = false
		$imgProgress.visible = false
		$imgSuccess.visible = true
		$imgProgressInRange.visible = false
		await get_tree().create_timer(3).timeout
		$".".queue_free()
	
	if(timeUntilFailed == 0):
		isActive = false
		$txtTitle.text = ""
		$txtProgress.text = ""
		$txtTimeLeft.text = "[center]Failed: %s[/center]" % questTitle
		MyGlobals.questResults.append( "Failed: %s" % questTitle )
		$imgFail.visible = true
		$imgProgress.visible = false
		$imgSuccess.visible = false
		$imgProgressInRange.visible = false
		await get_tree().create_timer(3).timeout
		$".".queue_free()

func is_on_player(body):
	var node = body
	while node != null:
		if node == MyGlobals.player:
			return true
		node = node.get_parent()
	return false

func _on_area_2d_body_entered(body):
	if( !isActive ):
		return
		
	var isPlayer = is_on_player(body)
	print("Collision ENTER. IsPlayer: %s" % isPlayer)
	allowProgress = true
	$imgProgressInRange.visible = true
	$imgProgress.visible = false
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if( !isActive ):
		return
		
	print("Collision EXIT.")
	allowProgress = false
	$imgProgressInRange.visible = false
	$imgProgress.visible = true
	pass # Replace with function body.