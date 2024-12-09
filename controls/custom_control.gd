@tool
extends HBoxContainer

@export var player : String = "p1"
@export var control : String = "jump":
	get: return control
	set(v):
		control = v
		%name.text = v.capitalize()
		if is_node_ready(): validate_control()
var control_name :
	get : return "%s_%s" % [player, control]

func _ready() -> void:
	var bb = load("res://blackboard.tres")
	if bb and "title_font" in bb: 	
		%name.add_theme_font_override("font", bb.title_font)
	await  get_tree().process_frame
	validate_control()
	
func validate_control():
	var events = InputMap.action_get_events(control_name)
	if not events: return
	%button.text = " %s " % events[0].as_text().trim_suffix(" (Physical)")


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%button.text = " ... "
	else:
		validate_control()

func _input(event: InputEvent) -> void:
	if not %button.button_pressed: return
	if not ((event is InputEventKey and event.is_pressed())or \
			(event is InputEventMouseButton and event.is_pressed()) or \
			(event is InputEventJoypadButton and event.is_pressed()) or \
			event is InputEventJoypadMotion and abs(event.axis_value) > 0.5):
		return
	InputMap.action_erase_events(control_name)
	InputMap.action_add_event(control_name,event)
	accept_event()
	%button.button_pressed = false
