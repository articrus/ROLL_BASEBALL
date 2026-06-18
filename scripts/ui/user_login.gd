extends Control
@onready var signUpEmail = $Panel/HBoxContainer/SignUp/EmailText
@onready var signUpPass = $Panel/HBoxContainer/SignUp/PasswordText
@onready var loginEmail = $Panel/HBoxContainer/SignIn/EmailText
@onready var loginPass = $Panel/HBoxContainer/SignIn/PasswordText
# Temporary
@onready var testLabel = $Panel/Label

# Attempts to login the user
func _login_user(email: String, password: String) -> void:
	if !_verfiy_email(email):
		pass
	var result = await AuthenticationManager._sign_in(email, password)
	if result.ok:
		var profile = await AuthenticationManager._load_profile()
		testLabel.text = "GAMES WON: " + str(profile.get("games_won", 0))
		Signalbus.user_login.emit()
	else:
		print("NOT OK")

# Attempts to register the user to a new account
func _sign_up_user(email: String, password: String) -> void:
	if !_verfiy_email(email):
		pass
	print("TEST")
	var result = await AuthenticationManager._sign_up(email, password)
	if result.ok:
		print("Account created successfully!")
		Signalbus.user_login.emit()
	else:
		print("NOT OK")

# Verifies if the email is in the correct format
func _verfiy_email(email: String) -> bool:
	return true

# Temporary, testing if everything works here
func _on_button_pressed() -> void:
	_sign_up_user(signUpEmail.text, signUpPass.text)

func _on_login_pressed() -> void:
	_login_user(loginEmail.text, loginPass.text)
