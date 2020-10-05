extends Label

onready var source = get_parent().get_parent()

func _ready():
	if source.player_died:
		text = Story.endings["robot dead end"]
	elif source.occupants_waking.size() > 0:
		text = Story.endings["incident report bad"]
	else:
		text = Story.endings["incident report good"]
	
	var name
	
	name = "alishia doil"
	text += '\n\n\n'
	text += name +"\n\n"
	if source.occupants_waking.has(name):
		text += Story.endings.get(name + " bad end", "")
	else:
		text += Story.endings.get(name + " good end", "")
		
	name = "reddy koppel"
	text += '\n\n\n'
	text += name +"\n\n"
	if source.occupants_waking.has(name):
		text += Story.endings.get(name + " bad end", "")
	else:
		text += Story.endings.get(name + " good end", "")
	
	name = "jonie hoff"
	text += '\n\n\n'
	text += name +"\n\n"
	if source.occupants_waking.has(name):
		text += Story.endings.get(name + " bad end", "")
	else:
		text += Story.endings.get(name + " good end", "")
	
	name = "steve lowry"
	text += '\n\n\n'
	text += name +"\n\n"
	if source.occupants_waking.has(name):
		text += Story.endings.get(name + " bad end", "")
	else:
		text += Story.endings.get(name + " good end", "")
	
	name = "whetu ng"
	text += '\n\n\n'
	text += name +"\n\n"
	if source.occupants_waking.has(name):
		text += Story.endings.get(name + " bad end", "")
	else:
		text += Story.endings.get(name + " good end", "")
	
	name = "anfelice gray"
	text += '\n\n\n'
	text += name +"\n\n"
	if source.occupants_waking.has(name):
		text += Story.endings.get(name + " bad end", "")
	else:
		text += Story.endings.get(name + " good end", "")
	
	text += '\n\n\n'
	text += """Credits
	
Writing - Ana Rakonjac
Graphics - Kayleigh Jaffe
Graphics - Hector Almendares
Programming - Tonic Artos

Music
Licensed Creative Commons - BY-NC-SA

01 Ghosts I
by
Nine Inch Nails

10 Ghosts II
by
Nine Inch Nails
"""
	
