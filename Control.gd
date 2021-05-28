extends CanvasLayer
var holding_item = null
onready var max_health = get_parent().get_node("Steve").max_health

signal health_updated()

func _input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
		

func _ready():
	pass


func _on_UserInterFace_health_updated(health):
	$Caracter/Bar/HealthBar.value = health
	$Caracter/Health.text = str(health) + "/" + str(max_health)
	pass # Replace with function body.
