extends Area2D


var entered = false


func _on_body_entered(_body: PhysicsBody2D):
	entered = true


func _on_body_exited(_body):
	entered = false

func _physics_process(_delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			translate(Vector2(60, 0))
