extends Node

const acceleration: float = 750
const braking: float = 300
const reverse_delay: float = 0.2
const reverse_amount: float = 300
const turn_amount: float = 3

const BOUNDARY_TOP: int = -1300
const BOUNDARY_BOTTOM: int = 1200
const BOUNDARY_LEFT: int = -2000
const BOUNDARY_RIGHT: int = 2500

@export var dialog_text: RichTextLabel

# Max speed is now controlled by air resistance alone
#const max_forwards_speed: float = 5
#const max_reverse_speed: float = 1

const air_resistance: float = 0.01 # multiplied by velocity squared, per second
const damping: float = 15.0 # does not scale with velocity, per second

var speed: float
var direction: float
var reverse_delay_elapsed: float
var is_reversing: bool

class TopicHover:
	var go: Callable
	var text: String
	
	static func new_no_topic() -> TopicHover:
		return TopicHover.new(Callable(), "")
	
	func _init(go: Callable, text: String) -> void:
		self.go = go
		self.text = text
		
	func is_topic() -> bool:
		return self.text != ""

var current: TopicHover = TopicHover.new_no_topic()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 0
	direction = PI
	reverse_delay_elapsed = 0
	is_reversing = false
	dialog_text.text = ""  # text sometimes put in for testing
	get_node("Area2D").connect("area_entered", body_entered)
	get_node("Area2D").connect("area_exited", body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("driving_accelerate"):
		# Attempting to accelerate
		if speed > 0:
			# Only switch from reverse after a delay
			if is_reversing:
				if reverse_delay_elapsed < reverse_delay:
					speed = 0
					reverse_delay_elapsed += delta
				else:
					is_reversing = false
					reverse_delay_elapsed = 0
					# will accelerate next frame
			else:
				speed += acceleration * delta
				#if speed > max_forwards_speed:
					#speed = max_forwards_speed
		# Attempting to brake
		else:
			speed += braking * delta
	if Input.is_action_pressed("driving_brake"):
		# Attempting to reverse
		if speed < 0:
			# Only reverse after a delay
			if not is_reversing:
				if reverse_delay_elapsed < reverse_delay:
					speed = 0
					reverse_delay_elapsed += delta
				else:
					is_reversing = true
					reverse_delay_elapsed = 0
					# will reverse next frame
			else:
				speed -= reverse_amount * delta
				#if speed < -max_reverse_speed:
					#speed = -max_reverse_speed
		# Attempting to brake
		else:
			speed -= braking * delta
	# TODO: Turn less when moving faster
	if Input.is_action_pressed("driving_left"):
		direction -= turn_amount * delta
	if Input.is_action_pressed("driving_right"):
		direction += turn_amount * delta
		
	# Air resistance (always against direction of travel, bigger for faster speeds)
	if speed > 0:
		speed -= air_resistance * delta * pow(speed, 2)
	elif speed < 0:
		speed += air_resistance * delta * pow(speed, 2)
		
	# Fixed damping (stops the car from rolling for too long at slower speeds, so that it comes to a complete stop instead)
	if speed > 0:
		speed -= damping * delta
		if speed < 0:
			speed = 0
	if speed < 0:
		speed += damping * delta
		if speed > 0:
			speed = 0
		
	#print("Speed: " + str(speed) + ", Direction: " + str(direction))
	self.position += Vector2.from_angle(direction - PI/2) * speed * delta
	self.rotation = direction
	
	# Stay within bounds
	if self.position.x > BOUNDARY_RIGHT:
		self.position.x = BOUNDARY_RIGHT
	if self.position.x < BOUNDARY_LEFT:
		self.position.x = BOUNDARY_LEFT
	if self.position.y > BOUNDARY_BOTTOM:
		self.position.y = BOUNDARY_BOTTOM
	if self.position.y < BOUNDARY_TOP:
		self.position.y = BOUNDARY_TOP

	# Go to level that we're driving over
	if Input.is_action_just_pressed("ui_accept"):
		if current.is_topic():
			current.go.call()

func body_entered(other: Area2D) -> void:
	print("Body entered")
	if other.has_method("go"):
		current = TopicHover.new(other.go, other.topic_name)
		dialog_text.text = "[center]Press SPACE or ENTER to go to " + current.text

func body_exited(other: Area2D) -> void:
	print("body exited")
	# TODO: Fix this and then display current_level as text (might want to remove current_level variable and just update text onscreen instead)
	current = TopicHover.new_no_topic()
	dialog_text.text = ""
