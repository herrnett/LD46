extends ColorRect

func newday():
	get_parent().get_node("Backdrop/nut").visible = true
	get_parent().get_node("Interactive/Nut/Nut").disabled = false
	
	if Globals.appleinsoil and Globals.soilwatered:
		if Globals.timeswatered >= 4 and Globals.timeswatered < 15:
			$tree.visible = true
			$hole.visible = false
			Globals.tree = 1
			match Globals.getseason():
				"spring": $tree.frame = 0
				"summer": $tree.frame = 6
				"autumn": $tree.frame = 12
				"winter": $tree.frame = 18
		elif Globals.timeswatered >= 15 and Globals.timeswatered < 24:
			Globals.tree = 2
			match Globals.getseason():
				"spring": $tree.frame = 1
				"summer": $tree.frame = 7
				"autumn": $tree.frame = 13
				"winter": $tree.frame = 19
		elif Globals.timeswatered >= 26:
			get_parent().get_node("Interactive/Hole/Hole").disabled = true
			Globals.tree = 3
			match Globals.getseason():
				"spring": $tree.frame = 2
				"summer": $tree.frame = 8
				"autumn": $tree.frame = 14
				"winter": $tree.frame = 20
			
	
	if Globals.soilstep >= 5 and !Globals.appleinsoil:
		$hole.visible = false
		get_parent().get_node("Interactive/Hole/Hole").disabled = true #and here's another one
	if Globals.dayssurvived == 2 and $apple.visible: 
		$apple.frame = 1
	elif Globals.dayssurvived >= 5 and Globals.dayssurvived < 10:
		color = Color("#639bff")
		$apple.visible = false
		get_parent().get_node("Interactive/Apple/Apple").disabled = true #Another instance of "That could've been one line"
		$cloud_01.visible = false
		$cloud_02.visible = false
		$summer_cloud_01.visible = true
		$Tilemap_spring.visible = false
		$Tilemap_summer.visible = true
		$cave.animation = "summer"
		$nuttree.frame = 1
	elif Globals.dayssurvived >= 10 and Globals.dayssurvived < 15:
		color = Color("#5b6ee1")
		$cloud_01.visible = true
		$cloud_02.visible = true
		$summer_cloud_01.visible = false
		$Tilemap_summer.visible = false
		$Tilemap_autumn.visible = true
		$cave.animation = "autumn"
		$nuttree.frame = 2
	elif Globals.dayssurvived >= 14 and Globals.dayssurvived < 20:
		color = Color("#3f3f74")
		$Tilemap_autumn.visible = false
		$Tilemap_winter.visible = true
		$cave.animation = "winter"
		$nuttree.frame = 3
