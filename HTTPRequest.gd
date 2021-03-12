extends HTTPRequest


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var scoreTableName = $ScoreTable/Panel/Name
onready var scoreTableScore = $ScoreTable/Panel/Score

# Called when the node enters the scene tree for the first time.
func _ready():
	_get_highscore()
	pass # Replace with function body.

func _get_highscore():
	var headers: PoolStringArray = ["Content-Type: application/json"];
	var data = {
		"gameId":"6046b9415fce370015f328be"
	}
	#self.set_use_threads(true);
	self.connect("request_completed",self,"doSomething");
	self.request("https://gapi-zhopio.herokuapp.com/score/getScoreByValue",headers,true,HTTPClient.METHOD_POST,JSON.print(data));

func doSomething(_result,response_code,_headers,body:PoolByteArray):
	if(response_code == 200):
		var data = body.get_string_from_utf8();
		var json = JSON.parse(data)
		
		if( json.result.status == 1 ):
			
			mostrarHighScore(json.result.data);
	else:
		print('Tenemos un dilema');
	pass

func mostrarHighScore(data):
	
	print(scoreTableName);
	scoreTableName.text = "Name";
	scoreTableScore.text = "Score";
	for i in data:
		scoreTableName.text += "\n" + str(i.name);
		scoreTableScore.text += "\n" + str(i.score);


func _on_GetScore_pressed():
	_get_highscore();
	pass # Replace with function body.
