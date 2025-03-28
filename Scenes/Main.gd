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

		region.center = _getPolygonCenter(polygons)

		var region_name = Label.new()
		region_name.text = region.region_name
		region_name.vertical_alignment = VERTICAL_ALIGNMENT_FILL
		region_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
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
