extends KinematicBody2D

export(NodePath)var route

export var max_health = 1000
export var max_magic = 1000
export var basic_damage = 20
export var basic_defende = 10
export var basic_shugong = 0
export var basic_shufang = 0
export var money = 0
export var juntuan = 0
export var level = 1
var state_machine

onready var userInterface = get_parent().get_node("UserInterFace")

var experience = 0
var experience_pool = 0 #经验池
var experience_required = get_required_experience(level+1)


onready var health = max_health setget _set_health
onready var magic = max_health setget _set_health

signal health_updated(health, magic)
signal dead()

var monirable = 0 ##物体进入藤子时 重复true和false来达到 实时检测的目的

var velocity = Vector2()
var cnt = 0
var derection = 0
export var JUMP = -800  #800合适
export var SPEED = 400  #300合适
var state = 0#0默认 1攀爬
var trans = 0#是否符合传送条件
var upOrDown = 0#上下梯子

var attacking = 0#攻击状态

var chase_target_state = 0
var target = 0
var target_derection = 1


func _ready():
	$AnimatedSprite.visible = false
	$AnimatedSprite2.visible = false
	state_machine = $AnimationTree.get("parameters/playback")
	$HBoxContainer.visible = false
	$fly_left.frame = $fly_right.frame
	for i in $HBoxContainer.get_children():
		i.visible = false
var items_in_range = {} ##掉落物范围检测 暂存数组

func get_required_experience(level):
	return 1*level-1

func gain_experience(amount):
	get_node("HBoxContainer/0").visible = true
	var str_amount = str(amount)
	for i in str_amount.length():
		get_node("HBoxContainer/"+str(i+1)).texture = load("res://EFECTIVE/js/digit/"+str_amount.substr(i,1)+str_amount.substr(i,1)+".png")
		get_node("HBoxContainer/"+str(i+1)).visible = true
	$AnimationPlayer.play("experience")
	experience_pool += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()
	userInterface.update_exp(int(experience*100/experience_required))

func level_up():
	level += 1
	experience_required = get_required_experience(level + 1)
	max_health += level * 10
	max_magic += level * 5
	basic_damage += level * 2
	basic_defende += level * 1
	basic_shugong += level
	basic_shufang += level
	
	$level_up.play()
	$AnimatedSprite3.visible = true
	$AnimatedSprite3.play("defalut")
	yield($AnimatedSprite3, "animation_finished")
	$AnimatedSprite3.visible = false
	$AnimatedSprite3.stop()
	userInterface.update_text(level, max_health, max_magic,
							 basic_damage, basic_defende,
							 basic_shugong, basic_shufang)
	
func gain_money(amount_m, amount_j):
	money += amount_m
	juntuan += amount_j
	userInterface.update_inventory(money, juntuan)
	
func gain_speed():
	SPEED *= 2
	$speed.start(10)
	$fly_left.visible = true
	$fly_right.visible = true
	
func gain_recover():
	$health.start(60*5)
	$recover.visible = true

func _input(event):
	if event.is_action_pressed("pickUp"):
		if items_in_range.size() > 0:
			var pickup_item = items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			gain_money(0, 0)
			items_in_range.erase(pickup_item)


func _physics_process(delta):
	if chase_target_state:##释放技能 跑到能达到怪物的地方
		var min_dist = 99999999
		move_to_target(delta, min_dist)
	else:
		game_play(delta)
	
func move_to_target(delta, min_dist):
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in enemies:
		var dist = sqrt(pow(i.position.y-position.y, 2) + pow(i.position.x-position.x, 2))
		if dist < min_dist and abs(i.position.y-position.y) <= 30: #垂直距离在同一层
			min_dist = dist
	if min_dist == 99999999: ##当前层没找到目标
		chase_target_state = 0
		return
	for i in enemies:
		if sqrt(pow(i.position.y-position.y, 2) + pow(i.position.x-position.x, 2)) == min_dist:
			#i.call_deferred("injury", 1)
			target = abs(position.x - i.position.x) + 30
			target_derection = position.x - i.position.x
			chase_target_state = 1
			break
	
	if target_derection > 0:
		target_derection = -1
		$Sprite.scale.x = -0.8
		$AnimatedSprite.scale.x = -0.8
	else:
		target_derection = 1
		$Sprite.scale.x = 0.8
		$AnimatedSprite.scale.x = 0.8
	##在范围内了 双方同时开始动画 进行伤害计算 并播放动画
	if target <= 100: #skill_dist 100
		chase_target_state = 0
		state_machine.travel("idle")
		attack()
		return
		
	velocity.x = delta * SPEED * target_derection * 50
	state_machine.travel("run")
	velocity.y = 0
	velocity = move_and_slide(velocity)
	yield(get_tree(), "idle_frame")


func game_play(delta):
	velocity.x = 0
	$CollisionShape2D.disabled = false
	if not is_on_floor():
		if state == 0:
			if derection == 1:
				velocity.x = SPEED * derection
			elif derection == -1:
				velocity.x = SPEED * derection
			##$Sprite.set()
			state_machine.travel("jump")
		else:
			if attacking == 0:##不在攻击状态中 才可以上下
				if Input.is_action_pressed("up"):
					upOrDown = -1
				elif Input.is_action_pressed("down"):
					upOrDown = 1
				else:
					state = 1
					upOrDown = 0
				state_machine.travel("clim")
				velocity.x = 0
	else:
		derection = 0
		if state == 0 and attacking == 0:##不在攻击状态中 才可以
			if Input.is_action_pressed("right"):
				derection = 1
				state_machine.travel("run")
				$Sprite.scale.x = 0.8
				$AnimatedSprite.scale.x = 0.8
				if Input.is_action_just_pressed("jump"):
					derection = 1
					velocity.y = JUMP
					state_machine.travel("jump")
			elif Input.is_action_pressed("left"):
				derection = -1
				state_machine.travel("run")
				$Sprite.scale.x = -0.8
				$AnimatedSprite.scale.x = -0.8
				if Input.is_action_just_pressed("jump"):
					derection = -1
					velocity.y = JUMP
					state_machine.travel("jump")
			elif Input.is_action_just_pressed("jump"):
				velocity.y = JUMP
			elif Input.is_action_pressed('attack'):
				var min_dist = 99999999
#				min_dist = closet_enemy(min_dist)
				closet_enemy(min_dist)
				move_to_target(delta, min_dist)
			elif trans == 1 and Input.is_action_pressed("up"):
				get_tree().change_scene("res://JiangLinXiJiao.tscn")
			elif Input.is_action_just_pressed("tab"):
				var min_dist = 99999999
#				min_dist = closet_enemy(min_dist)
			else:
				state_machine.travel("idle")
		else:
			if attacking == 0:##不在攻击状态中 才可以上下
				if Input.is_action_pressed("up"):
					state = 1
					velocity.x = 0
					upOrDown = -1
					state_machine.travel("clim")
				elif Input.is_action_pressed("down"):
					$CollisionShape2D.disabled = true
					state = 1
					upOrDown = 1
					state_machine.travel("clim")
				else:
					state = 1
					velocity.x = 0
					upOrDown = 0
	#Gravity
	if state != 1:#不等于攀爬
		velocity.y += 30
		velocity.x = SPEED * derection
	else:
		velocity.y = 300 * upOrDown
		if Input.is_action_pressed("left") and Input.is_action_just_pressed("jump"):
			$Sprite.scale.x = -0.8
			$AnimatedSprite.scale.x = -0.8
			state = 0
			derection = -1
			velocity.y = JUMP
		elif Input.is_action_pressed("right") and Input.is_action_just_pressed("jump"):
			$Sprite.scale.x = 0.8
			$AnimatedSprite.scale.x = 0.8
			state = 0
			derection = 1
			velocity.y = JUMP
		elif Input.is_action_just_pressed("jump"):
			derection = 0
			state = 0
	velocity = move_and_slide(velocity, Vector2.UP)
	#velocity.x = lerp(velocity.x, 0, 0.1)

func injury(damage):
	health -= damage
	state_machine.travel("injury")

func die():
	state_machine.travel("die")
	set_physics_process(false)
	
func closet_enemy(min_dist):
	## 遍历敌人组 选择两点间距离最近的敌人
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in enemies:
		var dist = sqrt(pow(i.position.y-position.y, 2) + pow(i.position.x-position.x, 2))
		if dist < min_dist:
			min_dist = dist
			velocity.x = i.position.x - position.x
			
	for i in enemies:
		if sqrt(pow(i.position.y-position.y, 2) + pow(i.position.x-position.x, 2)) == min_dist:
			#i.call_deferred("injury", 1)
			userInterface.get_node("Character").get_node("Target").visible = true
			userInterface.get_node("Character").get_node("Target").get_node("profile").texture = load("res://Monster_ui/profile/"+i.Name+".png")
			userInterface.get_node("Character").get_node("Target").get_node("name").text = i.Name
			userInterface.get_node("Character").get_node("Target").get_node("health_bar").value = i.get_node("HealthBar").get_node("HealthBar").value
			print(i.get_node("HealthBar").get_node("HealthBar").value)
			target = abs(position.x - i.position.x) + 30
			target_derection = position.x - i.position.x
			if target_derection > 0:
				target_derection = -1
			else:
				target_derection = 1
			chase_target_state = 1
			break
	
func _on_TransPort_body_entered(body):
	print(body)
	trans = 1

func _on_climb_body_exited(body):
	state = 0
	monirable = 0

func _on_TransPort_body_exited(body):
	trans = 0

func _on_Timer_timeout():
	attacking = 0

func _on_HitBox_body_entered(body):
	if !(body is KinematicBody2D):
		print("fuck that's not enemy!")
	if body.is_in_group("enemy"):
		body.call_deferred("injury", basic_damage)  ##对敌造成汇总伤害 自身基础+技能+装备
func _on_climb_body_entered(body):
	monirable = 1
	if cnt > 1 and Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		state = 1
	cnt+=1
	if cnt > 10:
		cnt = 2

func _on_Steve_injury():
	health -= 10
	
	pass # Replace with function body.

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health, magic)
		if health == 0:
			dead()
			
func dead():
	state_machine.travel("die")
	yield($Sprite,"animation_finished")
	##弹出死亡界面 这里先重新载入地图
	get_tree().change_scene("res://Level1.tscn")
	
func _on_Steve_health_updated(value):
	health -= value
	if health <= 0:
		velocity = Vector2.ZERO
		dead()
	state_machine.travel("injury")
	$FCTmgr.show_value(value)
	get_parent().get_node("UserInterFace").emit_signal("health_updated",health, magic)
	yield($AnimatedSprite,"animation_finished")
	pass # Replace with function body.


func _on_BattleTime_timeout():
	get_parent().get_node("Battle").stop()
	if	get_parent().get_node("AudioStreamPlayer").playing == false:
		get_parent().get_node("AudioStreamPlayer").play()
	pass # Replace with function body.


func _on_pickableArea_body_entered(body):
	items_in_range[body] = body

func _on_pickableArea_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)

func attack():
	attacking = 1
	get_parent().get_node("BattleSound").play()
	get_parent().get_node("AudioStreamPlayer").stop()
	if  get_parent().get_node("Battle").playing == false:
		get_parent().get_node("Battle").play()
		get_parent().get_node("BattleTime").start(25)

	$Timer.start(1.1)
	if $AnimatedSprite.scale.x > 0:
		state_machine.travel("attackRight")
	else:
		state_machine.travel("attackLeft")
	

func _on_self_heal_timeout():
	health += 4 ##每秒回复4点生命
	
	if health >= max_health:
		health = max_health
	magic += 2 ##2点魔法
	if magic >= max_magic:
		magic = max_magic
	get_parent().get_node("UserInterFace").emit_signal("health_updated",health, magic)
	pass # Replace with function body.

func get_save_stats():
	return {
		'filename' : get_filename(),
		'parent' : get_parent().get_path(),
		'x_pos' : position.x,
		'y_pos' : position.y,
		'stats' : {
			'max_health' : max_health,
			'max_magic' : max_magic,
			'health' : health,
			'magic' : magic,
			'basic_damage' : basic_damage,
			'basic_defende' : basic_defende,
			'money' : money,
			'juntuan' : juntuan,
			'exprience' : experience_pool,
		}
	}

func load_save_stats(stats): #需要保存的信息 目前是位置 属性
	position = Vector2(stats.x_pos, stats.y_pos)
	max_health = stats.stats.max_health
	max_magic = stats.stats.max_magic
	health = stats.stats.health
	magic = stats.stats.magic
	basic_damage = stats.stats.basic_damage
	basic_defende = stats.stats.basic_defende
	money = stats.stats.money
	juntuan = stats.stats.juntuan
	experience_pool = stats.stats.exprience




func _on_speed_timeout():
	$speed.stop()
	$fly_left.visible = false
	$fly_right.visible = false
	SPEED = 400
	pass # Replace with function body.


func _on_health_timeout():
	$health.stop()
	$recover.visible = false
	pass # Replace with function body.
