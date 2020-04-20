extends Node2D

onready var label = $RichTextLabel
var bbtextlayout = "%s\nfor %s Days\n\n%s\n%s\n%s"


func _ready():
	var array = Globals.stats()
	array.remove(0)
	array = [Globals.deathcause, Globals.dayssurvived] + array
	label.bbcode_text = bbtextlayout % array




func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and Globals.game_started:
		Globals.reset()
		Scenechanger.change_scene("res://scenes/Intro_scene.tscn")
