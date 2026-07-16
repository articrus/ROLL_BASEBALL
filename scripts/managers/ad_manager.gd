extends Node
## AdManager — Autoload singleton
## Handles fullscreen "interstitial" ads for the HTML5 export.
## The actual ad content is filled in on the JS side (see the
## injected script below) — this just controls the trigger,
## pause/resume, and skip-timer logic.

signal ad_started
signal ad_closed

const SKIP_DELAY_SECONDS := 5

var _js_callback: JavaScriptObject
var _ad_showing := false

func _ready() -> void:
	if not OS.has_feature("web"):
		return # No-op outside of web export (e.g. testing in editor)

	# Register a callback JS can call when the ad is closed.
	# Reaches window.parent first (the site embedding this game in an
	# iframe), falling back to the current window when run standalone
	# (e.g. opening index.html directly without an iframe wrapper).
	_js_callback = JavaScriptBridge.create_callback(_on_ad_closed_js)
	JavaScriptBridge.get_interface("window")._godotAdCallbackTemp = _js_callback
	JavaScriptBridge.eval(
		"(window.parent && window.parent !== window ? window.parent : window)" +
		".godotOnAdClosed = window._godotAdCallbackTemp;",
		true
	)


## Call this from anywhere in your game to trigger a fullscreen ad.
## Looks for a "godotShowAd" function defined on the WEBSITE
## (not inside this export) — see website-ad-snippet.html.
## Checks window.parent first (iframe embed), then window itself
## (standalone testing). If neither is found, this no-ops so the
## game doesn't break.
func show_interstitial_ad() -> void:
	if not OS.has_feature("web"):
		return # Skip ads entirely when running in editor/desktop
	if _ad_showing:
		return

	var has_ad_function: bool = JavaScriptBridge.eval(
		"typeof (window.parent && window.parent !== window ? window.parent : window).godotShowAd === 'function'",
		true
	)
	if not has_ad_function:
		push_warning("AdManager: godotShowAd not found — skipping ad.")
		return

	_ad_showing = true
	get_tree().paused = true
	ad_started.emit()

	JavaScriptBridge.eval(
		"(window.parent && window.parent !== window ? window.parent : window)" +
		".godotShowAd(%d);" % SKIP_DELAY_SECONDS,
		true
	)


func _on_ad_closed_js(_args) -> void:
	_ad_showing = false
	get_tree().paused = false
	ad_closed.emit()
