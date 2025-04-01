extends Node2D

@onready var mapImage = $RegionsImage
@onready var ArmyImage = $ArmyPlacementImage

@export var boarder_color = Color(0,0,0,1)

func _ready() -> void:
	load_regions()
	load_armies()

func _process(delta: float) -> void:
	pass


#########LOADING ARMIES###################

func load_armies():
	pass





##########LOADING REGIONS##################
func _getPolygonCenter(polygons: Array) -> Vector2:
	var center : Vector2 = Vector2.ZERO
	var numPoints : int = 0
	
	for polygon in polygons:
		for vertext in polygon:
			center += vertext
			numPoints += 1 

	return center / numPoints

## Function to check if a point is inside a polygon
#func is_point_in_polygon(point: Vector2, polygon: Array) -> bool:
#	var inside = false
#	var n = polygon.size()
#	for i in range(n):
#		var j = (i + 1) % n
#		if ((polygon[i].y > point.y) != (polygon[j].y > point.y)) and (point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x):
#			inside = !inside
#	return inside
#
## Function to calculate the distance to the edges of the polygon
#func distance_to_polygon_edges(point: Vector2, polygon: Array) -> float:
#	var min_distance = INF
#	for i in range(polygon.size()):
#		var j = (i + 1) % polygon.size()
#		var edge_start = polygon[i]
#		var edge_end = polygon[j]
#		var edge_vector = edge_end - edge_start
#		var edge_length = edge_vector.length()
#		
#		if edge_length == 0:
#			continue
#		
#		var t = clamp(((point - edge_start).dot(edge_vector)) / (edge_length * edge_length), 0, 1)
#		var closest_point = edge_start + edge_vector * t
#		var distance = point.distance_to(closest_point)
#		
#		min_distance = min(min_distance, distance)
#	return min_distance
#
## Function to find the pole of inaccessibility for a list of polygon objects
#func find_poles_of_inaccessibility(polygons: Array, sample_count: int = 1000) -> Array:
#	var poles = []
#	
#	for polygon in polygons:
#		# Assuming polygon has a method or property to get its points
#		var polygon_points = polygon.get_points()  # Adjust this line based on your polygon object
#		
#		var best_point = Vector2()
#		var max_min_distance = -1.0
#		
#		# Calculate bounding box for sampling
#		var min_x = polygon_points[0].x
#		var max_x = polygon_points[0].x
#		var min_y = polygon_points[0].y
#		var max_y = polygon_points[0].y
#		
#		for point in polygon_points:
#			min_x = min(min_x, point.x)
#			max_x = max(max_x, point.x)
#			min_y = min(min_y, point.y)
#			max_y = max(max_y, point.y)
#		
#		for i in range(sample_count):
#			var sample_point = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
#			if is_point_in_polygon(sample_point, polygon_points):
#				var distance = distance_to_polygon_edges(sample_point, polygon_points)
#				if distance > max_min_distance:
#					max_min_distance = distance
#					best_point = sample_point
#		
#		poles.append(best_point)
#	
#	return poles


#####################################3

func load_regions():
	var image = mapImage.get_texture().get_image()
	var pixel_color_dict = get_pixel_color_dict(image)
	var regions_dict = import_file("res://Map_Data/regions.txt")

	for region_color in regions_dict:
		var region = load("res://Scenes/region_area.tscn").instantiate()
		region.region_name = regions_dict[region_color]
		region.set_name(region_color)
		get_node("Regions").add_child(region)

		var bitmap = get_bitmap(image, region_color, pixel_color_dict)
		var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0,0), bitmap.get_size()), 0.1)

		region.center = _getPolygonCenter(polygons);

		var region_name = Label.new()
		region_name.text = region.region_name
		region_name.vertical_alignment = VERTICAL_ALIGNMENT_FILL
		region_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		region.center.x -= region_name.text.length() * 5 #move name to the left a little, since text goes to the right
		region_name.position = region.center
		region_name.anchor_bottom = true
		region.add_child(region_name)

		for polygon in polygons:
			var region_collision = CollisionPolygon2D.new()
			var region_polygon = Polygon2D.new()
			region_collision.polygon = polygon
			region_polygon.polygon = polygon


			var region_line = Line2D.new()
			region_line.points = polygon
			region_line.width = 5
			region_line.default_color = boarder_color




			region.add_child(region_collision)
			region.add_child(region_polygon)
			region.add_child(region_line)

			




func get_pixel_color_dict(image):
	var pixle_color_dict = {}
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixle_color = "#" + str(image.get_pixel(x, y).to_html(false))
			if pixle_color not in pixle_color_dict:
				pixle_color_dict[pixle_color] = []
			pixle_color_dict[pixle_color].append(Vector2(x,y))
	return pixle_color_dict

func get_bitmap(image, region_color, pixel_color_dict):
	var targetImage = Image.create(image.get_size().x, image.get_size().y, false, Image.FORMAT_RGBA8)
	for value in pixel_color_dict[region_color]:
		targetImage.set_pixel(value.x,value.y, "#000000")

	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(targetImage)
	return bitmap


func import_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", " "))
	else:
		print("Failed to open file: ", filepath)
		return null
