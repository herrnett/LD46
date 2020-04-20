extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.velocity = Vector2.ZERO
	$Player.is_alive = false
	$Player.set_camera()
	$Backdrop/cloud_01.position.x -= 6
	$Backdrop/cloud_02.position.x += 16
	$Backdrop/cloud_02.position.y += 3
	
	if Globals.tree != 0:
			$Backdrop/tree.visible = true
			$Backdrop/hole.visible = false
			match Globals.tree:
				1: $Backdrop/tree.frame = 0
				2: $Backdrop/tree.frame = 1
				3: $Backdrop/tree.frame = 2
