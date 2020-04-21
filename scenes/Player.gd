extends KinematicBody2D

var SPEED = 24
const GRAVITY = 2
onready var label = $RichTextLabel
onready var velocity:Vector2 = Vector2.ZERO
onready var tween = get_node("Tween")
var bbtextlayout = "[center]%s[/center]"
var is_alive = true
var gameover = false
var hasapple = false
var haswater = false
var waterspoiled = null
var badwater = null
var timeswateredtoday = 0
var wellused = 0

func _physics_process(delta):
	if is_alive and Globals.intro_done:
		if is_on_floor(): velocity.y = 0
		else: velocity.y += GRAVITY
		
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED * delta * 60
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED * delta * 60
		else:
			velocity.x = 0
		
		velocity = move_and_slide(velocity, Vector2.UP, true)
		
		match label.text:
			"drink":
				if Input.is_action_just_pressed("ui_accept"): 
					drink()
			"take water":
				if Input.is_action_just_pressed("ui_accept"):
					waterspoiled = badwater
					haswater = true
					set_label("drink")
					if !waterspoiled and Globals.getseason() != "summer":
						wellused += 1
						if wellused >= 15:
							set_label("chain broke")
							get_parent().get_node("Interactive/Well/Well").disabled = true
							haswater = false
			"sleep":
				if Input.is_action_just_pressed("ui_accept"): 
					if Globals.dayssurvived == 19: Scenechanger.change_scene("res://scenes/Win_scene.tscn")
					else: nextday()
			"follow":
				if Input.is_action_just_pressed("ui_accept"): 
					Globals.deathcause = "Lost"
					kill()
			"pour away":
				if Input.is_action_just_pressed("ui_accept"): 
					haswater = false
					unset_label()
			"water soil":
				if Input.is_action_just_pressed("ui_accept"): 
					if Globals.appleinsoil:
						if timeswateredtoday == 0: 
							Globals.timeswatered += 1
							if !waterspoiled: Globals.timeswatered += 1
							timeswateredtoday += 1
						elif timeswateredtoday == 1 and waterspoiled:
							Globals.timeswatered -= 1
					Globals.soilwatered = true
					haswater = false
					unset_label()
			"eat nut":
				if Input.is_action_just_pressed("ui_accept"):
					if Globals.hunger < 3: Globals.hunger += 1
					get_parent().get_node("Backdrop/nut").visible = false
					get_parent().get_node("Interactive/Nut/Nut").disabled = false #Jeez, that should've been one thing...
			"take apple":
				if Input.is_action_just_pressed("ui_accept"):
					get_parent().get_node("Backdrop/apple").visible = false
					get_parent().get_node("Interactive/Apple/Apple").disabled = true #aaaaaand again
					hasapple = true
					set_label("eat")
			"eat":
				if Input.is_action_just_pressed("ui_accept"): 
					eat()
			"throw away":
				if Input.is_action_just_pressed("ui_accept"): 
					hasapple = false
					unset_label()
			"bury apple":
				if Input.is_action_just_pressed("ui_accept"): 
					hasapple = false
					Globals.appleinsoil = true
					unset_label()
			"water tree":
				if Input.is_action_just_pressed("ui_accept"): 
					if timeswateredtoday == 0: 
						Globals.timeswatered += 1
						if !waterspoiled: Globals.timeswatered += 1
						timeswateredtoday += 1
					elif timeswateredtoday == 1 and waterspoiled:
						Globals.timeswatered -= 1
					haswater = false
					unset_label()
			"chain broke":
				if Input.is_action_just_pressed("ui_accept"): 
					unset_label()
			

func eat():
	if Globals.dayssurvived >= 2:
		Globals.healthy = false
		Globals.sickdaysleft = 3
	elif Globals.hunger < 3: Globals.hunger += 1
	hasapple = false
	unset_label()

func drink():
	if waterspoiled:
		Globals.healthy = false
		Globals.sickdaysleft = 3
	if Globals.thirst < 3: Globals.thirst += 1
	haswater = false
	unset_label()

func nextday():
	is_alive = false
	Scenechanger.animation_player.play("fade")
	yield(Scenechanger.animation_player, "animation_finished")
	sickcheck()
	sleep()
	Globals.dayssurvived += 1
	timeswateredtoday = 0
	get_parent().get_node("Backdrop").newday()
	position.x = 118
	if !Globals.healthy:
		match Globals.getseason():
			"spring": $Sprite.frame=5
			"summer": $Sprite.frame=6
			"autumn": $Sprite.frame=7
			"winter": $Sprite.frame=7
	else:
		match Globals.getseason():
			"spring": $Sprite.frame=0
			"summer": $Sprite.frame=1
			"autumn": $Sprite.frame=2
			"winter": $Sprite.frame=3
	yield(get_tree().create_timer(0.5), "timeout")
	Scenechanger.animation_player.play_backwards("fade")
	is_alive = true

func sickcheck():
	if Globals.sickdaysleft > 0:
		Globals.sickdaysleft -= 1
		SPEED = 16
	else:
		Globals.healthy = true
		SPEED = 24

func sleep():
	Globals.hunger -= 1
	Globals.thirst -= 1
	if !Globals.healthy: Globals.thirst -= 1
	if Globals.hunger < 1 and Globals. thirst < 1 and !Globals.healthy:
		Globals.deathcause = "Hell"
		kill(false)
	elif Globals.hunger < 1 and !Globals.healthy:
		Globals.deathcause = "Sick and hungry"
		kill(false)
	elif Globals.hunger < 1 and Globals.thirst < 1:
		Globals.deathcause = "Hunger/Thirst"
		kill(false)
	elif Globals.hunger < 1:
		Globals.deathcause = "So hungry..."
		kill(false)
	elif Globals.thirst < 1 and !Globals.healthy:
		Globals.deathcause = "Montezuma"
		kill(false)
	elif Globals.thirst < 1:
		Globals.deathcause = "So thirsty..."
		kill(false)

func kill(fade = true):
	is_alive = false
	velocity = Vector2.ZERO
	tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1,1), 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	Bgm.fade_out()
	if fade: Scenechanger.change_scene("res://scenes/Death_scene.tscn")
	else: Scenechanger.change_scene("res://scenes/Death_scene.tscn", 0.5, false)

func set_camera():
	$Camera2D.offset = Vector2.ZERO
	$Camera2D.zoom = Vector2(0.5,0.5)

func set_label(text):
#	label.modulate = Color(255, 255, 255, 0)
	label.bbcode_text = bbtextlayout % text
#	tween.interpolate_property(label, "modulate", label.modulate, Color(255, 255, 255, 255), 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
#	tween.start()
#	yield(tween, "tween_completed")
	
func unset_label():
	label.bbcode_text = ""

func _on_Killplane_body_entered(body):
	if body == self: 
		Globals.deathcause = "Leap of faith"
		kill()

func _on_Title_start_game():
	tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,0), 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(0.5,0.5), 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	Globals.game_started = true


func _on_Uncle_returns_theend():
	$Results.bbcode_text = "%s\n%s\n%s\n%s" % Globals.stats()
	tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1,1), 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	if !gameover:
		gameover = true
		var animation_player = $AnimationPlayer
		animation_player.play("fadeend")
		yield(animation_player, "animation_finished")
		animation_player.play("fadestats")
		yield(animation_player, "animation_finished")
		animation_player.play("fadethanks")
		yield(animation_player, "animation_finished")
	if Input.is_action_just_pressed("ui_accept"):
		Bgm.fade_out()
		Scenechanger.change_scene("res://scenes/Intro_scene.tscn")


func _on_Well_body_entered(body):
	if body == self: 
		if !haswater and !hasapple:
			badwater = false
			set_label("take water")
		elif haswater: set_label("pour away")
		else: set_label("throw away")


func _on_Well_body_exited(body):
	if body == self: 
		if !haswater and !hasapple and label.text != "chain broke":
			badwater = null
			unset_label()
		elif haswater: set_label("drink")
		elif hasapple: set_label("eat") 


func _on_Door_body_entered(body):
	if body == self: 
		if !haswater or !hasapple:
			set_label("sleep")


func _on_Door_body_exited(body):
	if body == self: 
		if !haswater and !hasapple:
			unset_label()


func _on_Cave_entrance_body_entered(body):
	if body == self: 
		if !haswater and !hasapple:
			set_label("follow")


func _on_Cave_entrance_body_exited(body):
	if body == self: 
		if !haswater and !hasapple:
			unset_label()


func _on_Cave_fountain_body_entered(body):
	if body == self: 
		if !haswater and !hasapple:
			if Globals.getseason() == "summer": badwater = false
			else: badwater = true
			set_label("take water")
		elif haswater: set_label("pour away")
		else: set_label("throw away") 


func _on_Cave_fountain_body_exited(body):
	if body == self: 
		if !haswater and !hasapple:
			badwater = null
			unset_label()
		elif haswater: set_label("drink")
		else: set_label("eat") 


func _on_Nut_body_entered(body):
	if body == self:
		if !haswater and !hasapple:
			set_label("eat nut")


func _on_Nut_body_exited(body):
	if body == self: 
		if !haswater and !hasapple:
			unset_label()


func _on_Apple_body_entered(body):
	if body == self: 
		if !haswater:
			set_label("take apple")


func _on_Apple_body_exited(body):
	if body == self: 
		if !haswater and !hasapple:
			unset_label()


func _on_Hole_body_entered(body):
	if body == self: 
		if !haswater and !hasapple and !Globals.appleinsoil:
			set_label("soft soil")
		elif haswater: 
			if get_parent().get_node("Backdrop/tree").visible: set_label("water tree")
			else: set_label("water soil")
		elif hasapple: set_label("bury apple") 
		if !Globals.appleinsoil: Globals.soilstep += 1


func _on_Hole_body_exited(body):
	if body == self: 
		if !haswater and !hasapple:
			unset_label()
		elif haswater: set_label("drink")
		else: set_label("eat") 
