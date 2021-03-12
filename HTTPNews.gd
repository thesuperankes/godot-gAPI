extends HTTPRequest

onready var newsName = $Panel/Name
onready var newsMessage = $Panel/Message

func _ready():
	# Create an HTTP request node and connect its completion signal
	_get_news();
	pass

func _get_news():
	var headers: PoolStringArray = ["Content-Type: application/json"];
	var data = {
		"gameId":"6046b9415fce370015f328be"
	}
	#self.set_use_threads(true);
	self.connect("request_completed",self,"_get_news_success");
	self.request("https://gapi-zhopio.herokuapp.com/news/getLastNew",headers,true,HTTPClient.METHOD_POST,JSON.print(data));

func _get_news_success(_result,response_code,_headers,body:PoolByteArray):
	var data = JSON.parse(body.get_string_from_utf8());
	if(data.result.status == 1):
		_getImage(data.result.data.image);
		newsName.text = str(data.result.data.title)
		newsMessage.text = str(data.result.data.message)

func _getImage(url):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var http_error = http_request.request(url)
	if http_error != OK:
		print("An error occurred in the HTTP request.")
# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var image_error = image.load_jpg_from_buffer(body)
	
	if image_error != OK:
		print("An error occurred while trying to display the image.")

	var texture = ImageTexture.new()
	texture.create_from_image(image)

	# Assign to the child TextureRect node
	$TextureRect.texture = texture


func _on_Button_pressed():
	_get_news();
