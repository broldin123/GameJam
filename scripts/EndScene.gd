extends Control

var completedQuestsString = ""
var failedQuestsString = ""
var totals = ""
var score = ""

var questList := ["Completed: Quest1", "Failed: Quest2", "Completed: Quest3", "Failed: Quest4"]

# Called when the node enters the scene tree for the first time.
func _ready():
	collateQuests()
	$txtResultsInfo.text = completedQuestsString + failedQuestsString + totals + score

func collateQuests():
	print("Printing Quests: ", global.questResults)
	var completedQuests := []
	var failedQuests := []
	# Iterate through the list of quest strings
	for quest_str in global.questResults:
		if quest_str.find("Completed:") != -1:
			# Extract the quest name and append it to completedQuests
			var quest_name = quest_str.replace("Completed: ", "")
			completedQuests.append(quest_name)
		elif quest_str.find("Failed:") != -1:
			# Extract the quest name and append it to failedQuests
			var quest_name = quest_str.replace("Failed: ", "")
			failedQuests.append(quest_name)
	# Concatenate the completed and failed quests into strings
	completedQuestsString = "Quests Completed:\n" + ", ".join(completedQuests)
	failedQuestsString = "\n\nQuests Failed:\n" + ", ".join(failedQuests)
	var totalNumQuests = completedQuests.size() + failedQuests.size()
	totals = "\n\nTotal Completed: %s of %s" % [completedQuests.size(), totalNumQuests]
	
	var completionPercentage = completedQuests.size() / float(totalNumQuests) * 100.0
	if completionPercentage > 90.0:
		score = "\n\nRating: Perfect Dad"
	elif completionPercentage > 75.0:
		score = "\n\nRating: Average Dad"
	elif completionPercentage > 50.0:
		score = "\n\nRating: Struggling Dad"
	elif completionPercentage > 30.0:
		score = "\n\nRating: Bag of Bones"
	else:
		score = "\n\nRating: Deadbeat Dad"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/TitleScene.tscn")
