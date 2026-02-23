extends Area2D

var speed = 1000
var direction = Vector2.UP  


func _ready():
	set_as_top_level(true)  
	$CollisionShape2D.connect("spawn_laser", Callable(self, "_on_spawn_laser"))  

func _process(delta):
	position += direction * speed * delta  


	if position.y < 0:
		queue_free()


func _on_area_entered(area: Area2D):
	if area.is_in_group("enemies"):  
		area.take_damage(1)  
		queue_free()  
