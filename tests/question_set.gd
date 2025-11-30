class_name QuestionSet extends Resource

@export_multiline var questions_data: String

var questions: Array[String]
var answers: Array[Array]
var is_correct: Array[Array]

var order: Array
var order_index

var question_block_regex := RegEx.new()
var answer_regex := RegEx.new()


func initialize():
	question_block_regex.compile(r"#\d+\s+(.*?)\s*(?:(?:<n>|<y>).+?\s*)+/")
	answer_regex.compile(r"<(n|y)>\s*(.+)")

	var question_index = 0
	var blocks_match = question_block_regex.search_all(questions_data)
	for block_match in blocks_match:
		var block = block_match.get_string()
		var question = block_match.get_string(1).strip_edges()
		questions.append(question)
		answers.append([])
		is_correct.append([])
		for ans_match in answer_regex.search_all(block):
			var tag = ans_match.get_string(1)
			var answer = ans_match.get_string(2).strip_edges()
			answers[question_index].append(answer)
			is_correct[question_index].append(tag == "y")
		question_index += 1
	
	order = range(blocks_match.size())
	order.shuffle()
	order_index = 0


func get_next_question():
	var next_question = {
		"question": questions[order[order_index]]
		, "answers":  answers[order[order_index]]
		, "is_correct": is_correct[order[order_index]]
	}
	order_index += 1
	return next_question

func get_question_count():
	return questions.size()

#var text := """
##1
#What is the capital of Great Britain?
#<n> Paris
#<y> London
#<n> Moscow
#/
#
##2
#What color is the sky?
#<n> Green
#<y> Blue
#<n> Red
#/
#"""

