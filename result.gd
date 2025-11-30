extends Control

var is_saved: bool
var student_name_edit: LineEdit

func _ready():
	var result = find_child("result") as Label
	result.text = "Your result is %s points" % TestScore.value
	result.text += "\n start at: %s\nend at: %s" % [TestScore.start_time, TestScore.end_time]
	
	student_name_edit = find_child("student_name_edit") as LineEdit
	student_name_edit.text_submitted.connect(save)
	
	var quit_button = find_child("quit") as Button
	quit_button.pressed.connect(quit)
	
	is_saved = false

func quit():
	print("quitting")
	if not is_saved:
		save(student_name_edit.text)
	get_tree().quit()

func save(student_name):
	var base_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	
	var dir = DirAccess.open(base_path)
	if not dir.dir_exists("TestResults"):
		dir.make_dir("TestResults")
	
	var dir_path = base_path.path_join("TestResults").path_join(student_name + ".txt")
	var file = FileAccess.open(dir_path, FileAccess.WRITE)
	if file:
		file.store_string(student_name + " has score of " + str(TestScore.value) + " points")
		file.store_string("\nstart at " + TestScore.start_time)
		file.store_string("\nended at " + TestScore.end_time)
		is_saved = true
		file.close()
	else:
		print(FileAccess.get_open_error())
