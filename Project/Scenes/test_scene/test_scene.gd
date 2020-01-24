extends CanvasLayer

onready var ent1 = $Entity as Entity
onready var ent2 = $Entity2 as Entity

func _ready() -> void:
	$Control/VBoxContainer/QuitBtn.grab_focus()
	
	randomize()
	print("ent1 Lv: ", ent1.lv)
	print("ent2 Lv: ", ent2.lv)
	print("entity 2 attack power: ", ent2.atk)
	print("hp of entity 1 : ", ent1.hp)
	ent1.take_damage(ent1.calculate_take_damage_from_entity(ent2))
	print("took ", ent1.previous_damage_taken, " damage. hp of entity 1 : ", ent1.hp)
	ent1.take_damage(ent1.calculate_take_damage_from_entity(ent2))
	print("took ", ent1.previous_damage_taken, " damage. hp of entity 1 : ", ent1.hp)
	ent1.take_damage(ent1.calculate_take_damage_from_entity(ent2))
	print("took ", ent1.previous_damage_taken, " damage. hp of entity 1 : ", ent1.hp)
	
	var LV = []
	for i in 100:
		LV.append(i+1)
	
	for i in LV:
		var a = ceil(1.3 * pow(i, 3.2) + (35 * i))
		print("LV: ", i, ": ", a)
	
#	for i in LV:
#		var exp_drop = ceil(120 * (pow(i, 0.9) / 6))
#		print("LV: ", i, ": drop ", exp_drop)


func _on_QuitBtn_pressed() -> void:
	get_tree().reload_current_scene()
