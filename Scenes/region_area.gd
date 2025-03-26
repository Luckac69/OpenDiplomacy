extends Area2D

var region_name = ""



func _on_child_entered_tree(node:Node) -> void:
	if node.is_class("Polygon2D"):
		node.color = Color(0,0,0,0)

func _on_mouse_entered() -> void:
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = Color(1,1,1,.5)

func _on_mouse_exited() -> void:
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = Color(0,0,0,0)



func _on_input_event(viewport:Node, event:InputEvent, shape_idx:int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		pass
