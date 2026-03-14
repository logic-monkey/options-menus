extends Control

func _ready() -> void:
	var bb = load("res://blackboard.tres")
	if not "players" in bb._data or not "buttons" in bb._data: return
	for p in bb._data.players:
		for b in bb._data.buttons:
			var c = preload("res://addons/options-menus/controls/custom_control.tscn")\
					.instantiate()
			c.player = p
			c.control = b
			%button_list.add_child(c)
			c.validate_control()


func _on_reset_pressed() -> void:
	InputMap.load_from_project_settings()
	_INIT.data.custom_controls = {}
	for button in %button_list.get_children(): button.validate_control()
