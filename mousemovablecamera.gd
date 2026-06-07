extends Camera2D
class_name MouseMoveableCamera2D

@export var pan_smoothing: float = 12.0
@export var zoom_smoothing: float = 10.0
@export var zoom_step: float = 0.15
@export var zoom_min: float = 0.2
@export var zoom_max: float = 5.0

@export_group("Pan Button")
@export var pan_button: MouseButton = MOUSE_BUTTON_RIGHT

var _pan_pressed: bool = false
var _target_position: Vector2
var _target_zoom: float

func _ready() -> void:
	_target_position = position
	_target_zoom = zoom.x

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == pan_button:
			_pan_pressed = event.pressed
			Input.set_default_cursor_shape(Input.CURSOR_DRAG if event.pressed else Input.CURSOR_ARROW)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_target_zoom = clamp(_target_zoom * (1.0 + zoom_step), zoom_min, zoom_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_target_zoom = clamp(_target_zoom / (1.0 + zoom_step), zoom_min, zoom_max)

	elif event is InputEventMouseMotion and _pan_pressed:
		_target_position -= event.relative / zoom

func _process(delta: float) -> void:
	position = position.lerp(_target_position, clamp(pan_smoothing * delta, 0.0, 1.0))
	zoom = zoom.lerp(Vector2(_target_zoom, _target_zoom), clamp(zoom_smoothing * delta, 0.0, 1.0))
