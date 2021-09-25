extends Sprite


var animation_player : AnimationPlayer

func _ready():
	animation_player = $AnimationPlayer
	animation_player.play("appear")


func handle_mouse_entered():
	if animation_player.current_animation == "appear":
		return
	animation_player.play("highlight")
	

func handle_mouse_exited():
	if animation_player.current_animation == "appear":
		return
	animation_player.play("back_to_normal")
