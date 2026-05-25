extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

var idle_tween: Tween
var is_triggered = false
# Lưu lại vị trí ban đầu để làm mốc bay lên xuống
@onready var start_pos = position

func _ready() -> void:
	start_bobbing()

func start_bobbing():
	idle_tween = create_tween().set_loops()
	# Tác động vào "position:y" của chính nó (self) thay vì "offset" của sprite
	# Bay lên 5 pixel so với vị trí gốc
	idle_tween.tween_property(self, "position:y", start_pos.y - 5.0, 1.2).set_trans(Tween.TRANS_SINE)
	# Trở về vị trí gốc
	idle_tween.tween_property(self, "position:y", start_pos.y, 1.2).set_trans(Tween.TRANS_SINE)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_triggered:
		is_triggered = true
		
		if idle_tween:
			idle_tween.kill()
		
		# Đảm bảo vị trí platform khớp lại mốc chuẩn trước khi rung
		position.y = start_pos.y
		
		shake_platform()
		await get_tree().create_timer(0.2).timeout
		anim.play("falling")
		await get_tree().create_timer(0.3).timeout
		fall()

func shake_platform():
	var tween = create_tween()
	# Rung toàn bộ platform (cả collision) theo trục X
	for i in range(2):
		tween.tween_property(self, "position:x", position.x + 4.0, 0.05)
		tween.tween_property(self, "position:x", position.x - 4.0, 0.05)
	tween.tween_property(self, "position:x", position.x, 0.05)

func fall():
	#anim.play("falling")
	#collision.set_deferred("disabled", true)
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 500, 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(queue_free)
