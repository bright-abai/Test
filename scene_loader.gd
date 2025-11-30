extends Node

var test_scene = preload("res://test.tscn")
var result_scene = preload("res://result.tscn")
var welcome_scene = preload("res://welcome.tscn")

func load_scene(scene):
	var root = get_tree().root
	var current = root.get_child(root.get_child_count() - 1)
	current.visible = false
	root.add_child(scene)
	
	await get_tree().create_timer(1).timeout 
	current.free()

# should be called as deferred
func load_test(resource_name):
	var test = test_scene.instantiate()
	test.prepare_question_set(resource_name)
	load_scene(test)

func load_result():
	load_scene(result_scene.instantiate())

func load_welcome():
	load_scene(welcome_scene.instantiate())
