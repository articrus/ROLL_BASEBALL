extends Control
# Sign Up
@onready var signUpEmail = $Panel/BoxContainer/SignUp/EmailText
@onready var signUpPass = $Panel/BoxContainer/SignUp/PasswordText
# Login
@onready var loginEmail = $Panel/BoxContainer/SignIn/EmailText
@onready var loginPass = $Panel/BoxContainer/SignIn/PasswordText
# Error/Confirmation Labels
@onready var loginWarning = $Panel/BoxContainer/LoginWarning
@onready var signUpWarning = $Panel/BoxContainer/SignUpWarning

# Attempts to login the user
func _login_user(email: String, password: String) -> void:
	if !_verify_info(email, password, true):
		return # If login info failed don't execute next steps
	var result = await AuthenticationManager._sign_in(email, password)
	if result.ok:
		var profile = await AuthenticationManager._load_profile()
		Signalbus.user_login.emit()
	else:
		_process_error(result, true)

# Attempts to register the user to a new account
func _sign_up_user(email: String, password: String) -> void:
	if !_verify_info(email, password, false):
		return # If signup info failed don't execute next steps
	var result = await AuthenticationManager._sign_up(email, password)
	if result.ok:
		_set_warning_text("Email confirmation sent!", false)
		Signalbus.user_login.emit()
	else:
		_process_error(result, false)

# Verfifies the entered information
func _verify_info(email: String, password: String, isLogin: bool) -> bool:
	_set_warning_text("", isLogin)
	if email == "" || password == "":
		_set_warning_text("Please fill out both fields", isLogin)
		return false
	return true

# Processes the error generated from logging in
func _process_error(result: Dictionary, isLogin: bool) -> void:
	var rawError = result.get("error", "")
	var toDisplay = "Something went wrong, please try again"
	if "Invalid login credentials" in rawError:
		toDisplay = "Incorrect email or password"
	elif "Email not confirmed" in rawError:
		toDisplay = "Please confirm your email"
	elif "missing email" in rawError:
		toDisplay = "Please enter your email"
	_set_warning_text(toDisplay, isLogin)

# Sets the warning text, for invalid login/sign up attempts
func _set_warning_text(warning: String, isLogin: bool) -> void:
	if isLogin:
		loginWarning.text = warning
	else:
		signUpWarning.text = warning

# Temporary, testing if everything works here
func _on_signup_pressed() -> void:
	_sign_up_user(signUpEmail.text, signUpPass.text)

func _on_login_pressed() -> void:
	_login_user(loginEmail.text, loginPass.text)

func _on_close_pressed() -> void:
	self.visible = false
