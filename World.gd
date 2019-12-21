extends Node2D

# Constants
const PLAYERSPEED = 300
const INITIALBALLSPEED = 100
# Global variables 
var screenSize
var padSize
var ballSpeed
var ballDirection
var leftScore
var rightScore

# Initioal function
func _ready():
	screenSize = get_viewport_rect().size
	padSize = get_node("leftPlayer").texture.get_size()
	ballSpeed = INITIALBALLSPEED
	ballDirection = Vector2(1.0, 0.0)
	leftScore = 0
	rightScore = 0
	set_process(true)
	pass 

# Function for every frame
func _process(delta):
	# Get positions
	var rightPlayerPosition = get_node("rightPlayer").position
	var leftPlayerPosition = get_node("leftPlayer").position
	var ballPosition = get_node("ball").position
	
	# Calculate colliders
	var leftCollider = Rect2(leftPlayerPosition - padSize * 0.5, padSize)
	var rightCollider = Rect2(rightPlayerPosition - padSize * 0.5, padSize)

	# Calculates players' next positions and define their top and bottom collision
	if(rightPlayerPosition.y > 0 and Input.is_action_pressed("ui_up")):
		rightPlayerPosition.y += -PLAYERSPEED * delta
	if(leftPlayerPosition.y > 0 and Input.is_action_pressed("left_up")):
		leftPlayerPosition.y += -PLAYERSPEED * delta
	if(rightPlayerPosition.y < screenSize.y and Input.is_action_pressed("ui_down")):
		rightPlayerPosition.y += PLAYERSPEED * delta
	if(leftPlayerPosition.y < screenSize.y and Input.is_action_pressed("left_down")):
		leftPlayerPosition.y += PLAYERSPEED * delta
	# Calculates the balls position and its collision
	ballPosition += ballDirection * ballSpeed * delta
	if((ballPosition.y < 0) or (ballPosition.y > screenSize.y)):
		ballDirection.y = -ballDirection.y
	if(leftCollider.has_point(ballPosition) or rightCollider.has_point(ballPosition)):
		ballDirection.x = -ballDirection.x
		ballDirection.y = randf() * 2 - 1
		ballDirection = ballDirection.normalized()
		if(ballSpeed < 300):
			ballSpeed *= 1.25
			
	# Resets the game in case of a match point.
	if(ballPosition.x < 0 or ballPosition.x > screenSize.x):
		if ballPosition.x < 0:
			rightScore += 1
		else:
			leftScore += 1
		
		ballSpeed = INITIALBALLSPEED
		ballPosition = screenSize * 0.5
		ballDirection.x = -ballDirection.x
		
		
		

	# Sets objects' positions
	get_node("rightPlayer").position = rightPlayerPosition
	get_node("leftPlayer").position = leftPlayerPosition
	get_node("ball").position = ballPosition
	
	# Set labels
	get_node("leftScore").text = String(leftScore)
	get_node("rightScore").text = String(rightScore)
	
	pass
	