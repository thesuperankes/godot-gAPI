extends HTTPRequest

onready var Name = $Panel/NameInput;
onready var Score = $Panel/ScoreInput;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	var headers: PoolStringArray = ["Content-Type: application/json","Zhopio-Game-Id: 6046b9415fce370015f328be","X-Authorized-By: "+ Score.text];
	var data = {
		"name":Name.text
	}
	
	print(JSON.print(headers));
	
	#self.set_use_threads(true);
	self.connect("request_completed",self,"_create_score_success");
	self.request("https://gapi-zhopio.herokuapp.com/score/create",headers,true,HTTPClient.METHOD_POST,JSON.print(data));

func _create_score_success(_result,response_code,_headers,body:PoolByteArray):
	var data = body.get_string_from_utf8();
	Name.text = "";
	Score.text = "";
