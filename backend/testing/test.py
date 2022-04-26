import requests

class TestClass:
	def test_hello_world(self):
		response = requests.get("http://127.0.0.1:5000/")
		assert(response.status_code == 200)


	def test_register_user(self):
		data = {
			"username": "test_user_1",
			"password": "1234"
		}
		response = requests.post("http://127.0.0.1:5000/api/register_user", data=data)
		assert(response.status_code == 200)

	def test_remove_user(self):
		data = {"username": "test_user_1"}
		response = requests.post("http://127.0.0.1:5000/api/remove_user", data=data)
		assert(response.status_code == 200)

