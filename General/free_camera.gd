extends Camera2D

var move_camera: bool = false
var last_mouse_position: Vector2
var target_position: Vector2
var target_zoom: Vector2

const min_zoom: Vector2 = Vector2(0.3, 0.3)
const max_zoom: Vector2 = Vector2(2, 2)
const min_pos: Vector2 = Vector2(-1000, 0)
const max_pos: Vector2 = Vector2(15000, 2500)
const keyboard_move_amount: Vector2 = Vector2(1500, 132 * 3)
const move_lerp_speed: float = 10.0 # proportion it should move in 1 second
const zoom_lerp_speed: float = 10.0
const mousewheel_zoom_amount: float = 1.1
const keyboard_zoom_amount: float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position = position
	target_zoom = zoom


func _input(event: InputEvent) -> void:
	# Middle mouse button to move camera
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_MIDDLE:
		# Pressed
		if event.pressed:
			move_camera = true
		# Released
		else:
			move_camera = false
			
	# Middle mouse button scroll
	if Input.is_action_just_released("zoom_in"):
		# Zoom around mouse position by ensuring the mouse does not move in world space
		# TODO: Lerp mouse wheel zoom (won't work with current implementation - will need to calculate the offset)
		var mouse_before_zoom: Vector2 = get_global_mouse_position()
		self.zoom *= 1.1
		if self.zoom > max_zoom:
			self.zoom = max_zoom
		target_zoom = self.zoom
		self.position += mouse_before_zoom - get_global_mouse_position()
		target_position = self.position
	if Input.is_action_just_released("zoom_out"):
		# Zoom around mouse position by ensuring the mouse does not move in world space
		var mouse_before_zoom: Vector2 = get_global_mouse_position()
		self.zoom /= mousewheel_zoom_amount
		if self.zoom < min_zoom:
			self.zoom = min_zoom
		target_zoom = self.zoom
		self.position += mouse_before_zoom - get_global_mouse_position()
		target_position = self.position
		
	# Keyboard movement
	if Input.is_action_just_pressed("ui_left"):
		target_position.x -= keyboard_move_amount.x
	if Input.is_action_just_pressed("ui_right"):
		target_position.x += keyboard_move_amount.x
	if Input.is_action_just_pressed("ui_up"):
		target_position.y -= keyboard_move_amount.y
	if Input.is_action_just_pressed("ui_down"):
		target_position.y += keyboard_move_amount.y

	# Keyboard zoom
	if Input.is_action_just_pressed("zoom_out_key"):
		# Zoom out around centre of screen
		target_zoom /= keyboard_zoom_amount
		if target_zoom < min_zoom:
			target_zoom = min_zoom
	if Input.is_action_just_pressed("zoom_in_key"):
		# Zoom in around centre of screen
		target_zoom *= keyboard_zoom_amount
		if target_zoom > max_zoom:
			target_zoom = max_zoom
		
		
func _process(_delta: float) -> void:
	# Position
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	if not move_camera:
		# If MMB isn't pressed, lerp the camera to the keyboard control
		position = lerp(position, target_position, move_lerp_speed*_delta)
	else:
		# If MMB is pressed, do mouse controls only (cancel any lerping with keyboard controls) 
		if mouse_position != last_mouse_position:
			self.position -= (mouse_position - last_mouse_position) / self.zoom.x
			# if self.position.x < min_pos.x:
			# 	self.position.x = min_pos.x
			# if self.position.y < min_pos.y:
			# 	self.position.y = min_pos.y
			# if self.position.x > max_pos.x:
			# 	self.position.x = max_pos.x
			# if self.position.y > max_pos.y:
			# 	self.position.y = max_pos.y
			target_position = position
	last_mouse_position = mouse_position

	# Zoom
	zoom = lerp(zoom, target_zoom, zoom_lerp_speed*_delta)

	# Keep target position within bounds
	if target_position.x < min_pos.x:
		target_position.x = min_pos.x
	if target_position.y < min_pos.y:
		target_position.y = min_pos.y
	if target_position.x > max_pos.x:
		target_position.x = max_pos.x
	if target_position.y > max_pos.y:
		target_position.y = max_pos.y