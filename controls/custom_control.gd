extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bb = load("res://blackboard.tres")
	if bb and "title_font" in bb: 	
		%name.add_theme_font_override("font", bb.title_font)
