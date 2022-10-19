extends KinematicBody2D

const speedUp = Vector2(0, -1)
const flap = 200
const maxFallSpeed = 200
const gravity = 10

var motion = Vector2()
var score = 0
var wallGenerator = preload("res://Walls.tscn")

onready var bemTiVi = $BemTiVi
onready var demais = $Demais

func _ready():
	pass

func _physics_process(delta):
	motion.y += gravity
	if motion.y > maxFallSpeed:
		motion.y = maxFallSpeed
	
	if Input.is_action_just_pressed("flap"):
		flap()

	motion = move_and_slide(motion, speedUp)
	
	get_parent().get_parent().get_node("CanvasLayer/RichTextLabel").text = str(score)

func flap():
	motion.y = -flap
	bemTiVi.play()

func wallReset():
	print("wallReset")
	var wallInstance = wallGenerator.instance()
	wallInstance.position = Vector2(1250, rand_range(-120, 200))
	get_parent().call_deferred("add_child", wallInstance)
	
func _on_Resetter_body_entered(body):
	if body.name == "Walls":
		body.queue_free()
		wallReset()
		
func _on_Detect_body_entered(body):
	if body.name == "Walls":
		get_tree().reload_current_scene()
	if body.name == "Floor":
		get_tree().reload_current_scene()
		
func _on_Detect_area_entered(area):
	if area.name == "PointsArea":
		demais.play()
		score += 1
