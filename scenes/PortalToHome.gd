extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	#translate(Vector2(0, 200))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !self.visible:
		return
	
	if global.workPlayer == null:
		return
		
	if global.workPlayer.global_position == null:
		return
	
	var myPos = self.global_position
	var distToPlayer = myPos.distance_to(global.workPlayer.global_position)
	#print("CurDist: ", distToPlayer)
	if distToPlayer < 50:
		global.PortalToHomeTaken()
		self.visible = false
	pass
