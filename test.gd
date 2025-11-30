extends Control

var timer_panel: Panel;
var timer_panel_size: float
var timer: float
var question_time: float = 30

var question_set: QuestionSet
var question_number = 1
var question_count = 0
var question_order
var answer_shuffle: Array
var current_question

var question_label: RichTextLabel
var question_count_label: Label
var test_score_label: Label
var answer_btns: Array[Node]
var confirm_btn: Button

var selected_answers: Array
var test_score: int

func _ready():
	timer_panel = find_child("Timer") as Panel;
	timer_panel_size = timer_panel.size.x
	timer = question_time
	
	confirm_btn = find_child("Confirm") as Button
	confirm_btn.pressed.connect(confirm_answer)
	
	question_count = question_set.get_question_count()
	question_label = find_child("Question") as RichTextLabel
	question_count_label = find_child("QuestionCount") as Label
	test_score = 0
	test_score_label = find_child("TestScore") as Label
	test_score_label.text = "%s pt" % test_score
	
	var i = 0
	var answers_parent = find_child("Answers")
	answer_btns = answers_parent.get_children()
	for btn in answer_btns:
		btn.toggled.connect(toggle_answer.bind(i))
		i += 1
	
	TestScore.start_time = Time.get_datetime_string_from_system(false, true)
	next_question()

func _process(delta):
	timer -= delta
	if (timer < 0):
		next_question()
	timer_panel.size.x = timer / question_time * timer_panel_size

func prepare_question_set(resource_name):
	question_set = load(resource_name) as QuestionSet
	question_set.initialize()

func next_question():
	if question_number > question_count:
		finish_test()
		return
		
	timer = question_time
	
	current_question = question_set.get_next_question()
	question_label.text = "%s. %s" % [question_number, current_question.question]
	question_count_label.text = "%s/%s" % [question_number, question_count]
	question_number += 1
	
	for btn in answer_btns:
		btn.visible = false
	
	var answer_count = current_question.answers.size()
	answer_shuffle = range(answer_count)
	answer_shuffle.shuffle()
	for index in range(answer_count):
		var answer_index = answer_shuffle[index]
		var answer_btn = answer_btns[index]
		answer_btn.visible = true
		answer_btn.text = current_question.answers[answer_index]
		answer_btn.set_pressed_no_signal(false)

func toggle_answer(toggled_on, index):
	if toggled_on:
		selected_answers.append(index)
	else:
		selected_answers.erase(index)

func confirm_answer():
	var score_delta = 0
	var not_selected_correct_answers = {}
	for index in range(answer_shuffle.size()):
		if current_question.is_correct[index]:
			not_selected_correct_answers[index] = 0
	for answer in selected_answers:
		var original_index = answer_shuffle[answer]
		if current_question.is_correct[original_index]:
			score_delta += 1
			not_selected_correct_answers.erase(original_index)
		else:
			score_delta -= 1
	
	for answer in not_selected_correct_answers:
		score_delta -= 1
	
	if score_delta > 0:
		test_score += score_delta
	test_score_label.text = "%s pt" % test_score
	selected_answers.clear()
	next_question()

func finish_test():
	TestScore.value = test_score
	TestScore.end_time = Time.get_datetime_string_from_system(false, true)
	SceneLoader.load_result()
