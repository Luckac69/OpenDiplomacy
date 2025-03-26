extends Camera2D

@export var zoomSpeed : float = 10;

var zoomTarget : Vector2

var dragStartMousePostion : Vector2
var dragStartCamaraPosition : Vector2
var isDragging : bool = false

func _ready() -> void:
	zoomTarget = zoom

func _process(delta: float) -> void:
	Zoom(delta)
	SimplePan()
	ClickAndDrag()

func Zoom(delta):
	if Input.is_action_just_pressed("CamaraZoomIn"):
		zoomTarget *= 1.1
	if Input.is_action_just_pressed("CamaraZoomOut"):
		zoomTarget *= .9

	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)

func SimplePan():
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("CamaraMoveRight"):
		moveAmount.x += 1
	if Input.is_action_pressed("CamaraMoveLeft"):
		moveAmount.x -= 1
	if Input.is_action_pressed("CamaraMoveUp"):
		moveAmount.y -= 1
	if Input.is_action_pressed("CamaraMoveDown"):
		moveAmount.y += 1
	moveAmount = moveAmount.normalized()
	position += moveAmount * 1/zoom

func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("CamaraPan"):
		dragStartMousePostion = get_viewport().get_mouse_position()
		dragStartCamaraPosition = position
		isDragging = true

	if isDragging and Input.is_action_just_released("CamaraPan"):
		isDragging = false

	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePostion
		position = dragStartCamaraPosition - moveVector * 1/zoom.x
