extends Control

# counds down every tick
# when it reaches zero, the quest is failed
var timeUntilFailed = 10.0

# counts up when button is held
# when it reaches timeTotalRequired, the quest is completed
var timeProgressed = 0.0

# Doesnt change, this is the total time required
var timeTotalRequired = 0.0

var isActive = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_setup("Do it,", 3, 10)
	pass

func _setup(title_, progressTimeReq_, timeLimit_):
	timeUntilFailed = timeLimit_
	timeProgressed = 0
	timeTotalRequired = timeLimit_
	isActive = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( isActive ):
		timeUntilFailed -= delta
		
		
	$txtTimeLeft.text = "[center]%ss[/center]" % int(timeUntilFailed)
	
	var timeProgressed = int( (timeProgressed / timeTotalRequired) * 100 )
	$txtProgress.text = "[center]%s%%[/center]" % timeProgressed
	
	pass
