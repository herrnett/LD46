extends KinematicBody2D

signal theend

onready var label = $RichTextLabel
const SPEED = 15
var motion = Vector2.ZERO
var textdone = false
var gameover = false
var i = 0
var bbtextlayout = "[center]%s[/center]"
var uncle_text = [
	"Good to see\nyou well.",
	"The land is\n safe again.",
	"And so\nare we."
]

func _ready():
	label.visible_characters = 0
	label.bbcode_text = bbtextlayout % uncle_text[i]
	if Globals.stats() == ["Healthy", "Perfect", "Perfect", "Max"]:
			uncle_text.append("...")
			uncle_text.append("I'm proud\nof you.")

func _physics_process(delta):
	if position.x < 24:
		motion.x = SPEED * delta * 60
		motion = move_and_slide(motion)
	else:
		if Input.is_action_just_pressed("ui_accept"):
			if textdone and i < uncle_text.size()-1:
				label.visible_characters = 0
				i += 1
				label.bbcode_text = bbtextlayout % uncle_text[i]
				textdone = false
			elif textdone: 
				label.visible_characters = 0 
				gameover = true
			if !textdone: 
				$Timer.start()
				$AudioStreamPlayer.play()
			else: 
				$Timer.stop()
				$AudioStreamPlayer.stop()
		if gameover:
			emit_signal("theend")


func _on_Timer_timeout():
	if !textdone:
		label.visible_characters += 1
		if label.visible_characters == label.text.length(): 
			$AudioStreamPlayer.stop()
			textdone = true


