extends Control

@export var R10: Button
@export var R11: Button
@export var P7: Button
@export var P8: Button
@export var P9: Button
@export var P10: Button
@export var P11: Button

func _ready():
	R10.pressed.connect(SceneLoader.load_test.bind("tests/R10.tres"))
	R11.pressed.connect(SceneLoader.load_test.bind("tests/R11.tres"))
	P7.pressed.connect(SceneLoader.load_test.bind("tests/P7.tres"))
	P8.pressed.connect(SceneLoader.load_test.bind("tests/P8.tres"))
	P9.pressed.connect(SceneLoader.load_test.bind("tests/P9.tres"))
	P10.pressed.connect(SceneLoader.load_test.bind("tests/P10.tres"))
	P11.pressed.connect(SceneLoader.load_test.bind("tests/P11.tres"))
