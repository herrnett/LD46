extends KinematicBody2D

onready var label = $RichTextLabel
onready var motion = Vector2.ZERO
const SPEED = 20
var musicstarted = false
var textdone = false
var leaving = false
var i = 0
var bbtextlayout = "[center]%s[/center]"
var uncle_text = [
#	"My nephew.",
#	"I must go.",
#	"Dark times\nare upon us.",
#	"Your uncle\nhas to help.",
#	"Wait for me.",
	"Be safe."
]

func _ready():
	label.visible_characters = 0
	label.bbcode_text = bbtextlayout % uncle_text[i]

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") and Globals.game_started:
		if textdone and i < uncle_text.size()-1:
			label.visible_characters = 0
			i += 1
			label.bbcode_text = bbtextlayout % uncle_text[i]
			textdone = false
		elif textdone: 
			label.visible_characters = 0 
			leaving = true
		if !textdone: 
			$Timer.start()
			$AudioStreamPlayer.play()
		else: 
			$Timer.stop()
			$AudioStreamPlayer.stop()
	if leaving:
		motion.x = -SPEED * delta * 60
		motion= move_and_slide(motion)
		if !musicstarted:
			musicstarted = true
			Bgm.fade_in()
		if position.x < 65: 
			Globals.intro_done = true
			queue_free()


func _on_Timer_timeout():
	if !textdone:
		label.visible_characters += 1
		if label.visible_characters == label.text.length(): 
			$AudioStreamPlayer.stop()
			textdone = true
