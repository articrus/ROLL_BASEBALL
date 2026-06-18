extends Node
# Supabase API URL and Key
const AUTH_URL = "https://jxxqpxwwmvoqiuazemot.supabase.co/auth/v1/"
const REST_URL = "https://jxxqpxwwmvoqiuazemot.supabase.co/rest/v1/"
const API_KEY = "sb_publishable_aGa-4mc9PE8RCCSTuJIWKA_O7yaAB0V"
# Current ID and access token
var current_user_id: String = ""
var access_token: String = ""

##--- Auth functions
func _sign_up(email: String, password: String) -> Dictionary:
	var res = await _post(
		AUTH_URL + "signup",
		{ "email": email, "password": password},
		_anon_headers()
	)
	if res.status == 200 and res.body.get("access_token", "") != "":
		access_token = res.body["access_token"]
		current_user_id = res.body["user"]["id"]
		return {"ok": true }
	return {"ok": false, "error": res.body.get("msg", "Unknown error")}

func _sign_in(email: String, password: String) -> Dictionary:
	var res = await _post(
		AUTH_URL + "token?grant_type=password",
		{"email": email, "password": password},
		_anon_headers()
	)
	if res.status == 200 and res.body.get("access_token", "") != "":
		access_token = res.body["access_token"]
		current_user_id = res.body["user"]["id"]
		return {"ok": true}
	return {"ok": false, "error": res.body.get("error_description", "Unknown error")}

func _sign_out() -> void:
	current_user_id = ""
	access_token = ""

##--- Data Functions
func _save_stats(stats: Dictionary) -> bool:
	if current_user_id == "":
		return false
	var http = HTTPRequest.new()
	add_child(http)
	var url = REST_URL + "player_stats?id=eq." + current_user_id
	http.request(url, _auth_headers() + ["Prefer: return=minimal"],
	HTTPClient.METHOD_PATCH, JSON.stringify(stats))
	var response = await http.request_completed
	http.queue_free()
	return response[1] == 204

func _load_profile() -> Dictionary:
	if current_user_id == "":
		return {}
	var http = HTTPRequest.new()
	add_child(http)
	var url = REST_URL + "player_stats?id=eq." + current_user_id + "&select=*"
	http.request(url, _auth_headers(), HTTPClient.METHOD_GET)
	var response = await http.request_completed
	http.queue_free()
	var body = JSON.parse_string(response[3].get_string_from_utf8())
	if body and body.size() > 0:
		return body[0]
	return {}

##--- Helper Functions
func _auth_headers() -> Array:
	return [
		"Content-Type: application/json",
		"apikey: " + API_KEY,
		"Authorization: Bearer " + access_token,
	]

func _anon_headers() -> Array:
	return [
		"Content-Type: application/json",
		"apikey: " + API_KEY,
	]

func _post(url: String, body: Dictionary, headers: Array) -> Dictionary:
	var http = HTTPRequest.new()
	add_child(http)
	http.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))
	var response = await http.request_completed
	http.queue_free()
	
	var status: int = response[1]
	var raw: String = response[3].get_string_from_utf8()
	print("HTTP stauts: ", status)
	print("HTTP raw response: ", raw)
	var parsed = JSON.parse_string(raw)
	return {"status": status, "body": parsed if parsed else {}}
