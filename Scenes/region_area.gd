extends Area2D

var region_name : String
var armyPlacement : Vector2
var center : Vector2
var boundingBox : Vector4

##Lable
var lable



func onready():
	lable.position = center
	pass
	


func _on_child_entered_tree(node:Node) -> void:
	if node.is_class("Polygon2D"):
		node.color = Color(0,0,0,0)

func _on_mouse_entered() -> void:
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = Color(1,1,1,.5)
	print(region_name + "\t" + str(boundingBox))

func _on_mouse_exited() -> void:
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = Color(0,0,0,0)



func _on_input_event(viewport:Node, event:InputEvent, shape_idx:int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		pass
