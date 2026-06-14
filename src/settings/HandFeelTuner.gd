## 手感参数热调辅助类
## 通过 MCP 的 game_eval 或 game_set_property 实时调整参数
class_name HandFeelTuner
extends RefCounted

## 单例实例
static var _instance: HandFeelTuner

## 当前配置
var settings: HandFeelSettings

## 配置文件路径
const SETTINGS_PATH := "res://settings/hand_feel.tres"

## 变更回调列表
var _callbacks: Array[Callable] = []


## 获取单例
static func get_instance() -> HandFeelTuner:
	if not _instance:
		_instance = HandFeelTuner.new()
		_instance._load_settings()
	return _instance


## 加载配置文件
func _load_settings() -> void:
	if ResourceLoader.exists(SETTINGS_PATH):
		settings = load(SETTINGS_PATH) as HandFeelSettings
		settings.changed.connect(_on_settings_changed)
	else:
		settings = HandFeelSettings.new()
		ResourceSaver.save(settings, SETTINGS_PATH)


## 配置变更回调
func _on_settings_changed() -> void:
	for callback in _callbacks:
		callback.call(settings)


## 注册变更监听
func register_callback(callback: Callable) -> void:
	if callback not in _callbacks:
		_callbacks.append(callback)


## 取消注册
func unregister_callback(callback: Callable) -> void:
	_callbacks.erase(callback)


## MCP 热调入口：更新单个参数
## 用法: game_eval("HandFeelTuner.get_instance().tune_param('card_move_duration', 0.2)")
func tune_param(param_name: String, value: Variant) -> void:
	if param_name in settings:
		settings[param_name] = value
		settings.emit_changed()
		push_warning("[HandFeel] %s = %s" % [param_name, value])


## MCP 热调入口：批量更新参数
## 用法: game_eval("HandFeelTuner.get_instance().tune_batch({'card_move_duration': 0.2, 'card_focus_scale': 1.2})")
func tune_batch(params: Dictionary) -> void:
	for key in params.keys():
		if key in settings:
			settings[key] = params[key]
	settings.emit_changed()
	push_warning("[HandFeel] Batch update: %d params" % params.size())


## MCP 热调入口：打印当前所有参数
## 用法: game_eval("return HandFeelTuner.get_instance().dump_params()")
func dump_params() -> String:
	return JSON.stringify(settings.to_debug_dict(), "  ")


## MCP 热调入口：重置为默认值
## 用法: game_eval("HandFeelTuner.get_instance().reset_defaults()")
func reset_defaults() -> void:
	settings = HandFeelSettings.new()
	ResourceSaver.save(settings, SETTINGS_PATH)
	settings.changed.connect(_on_settings_changed)
	_on_settings_changed()
	push_warning("[HandFeel] Reset to defaults")


## 保存当前配置到文件
## 用法: game_eval("HandFeelTuner.get_instance().save()")
func save() -> void:
	ResourceSaver.save(settings, SETTINGS_PATH)
	push_warning("[HandFeel] Saved to " + SETTINGS_PATH)


## 快捷预设：快速模式
func preset_fast() -> void:
	tune_batch({
		"card_move_duration": 0.15,
		"card_focus_duration": 0.1,
		"draw_duration": 0.2,
		"discard_duration": 0.15,
		"shuffle_duration": 0.4,
		"block_duration": 0.2,
		"damage_popup_duration": 0.5,
	})


## 快捷预设：慢动作模式（调试用）
func preset_slow() -> void:
	tune_batch({
		"card_move_duration": 0.5,
		"card_focus_duration": 0.3,
		"draw_duration": 0.6,
		"discard_duration": 0.5,
		"shuffle_duration": 1.2,
		"block_duration": 0.6,
		"damage_popup_duration": 1.5,
	})


## 快捷预设：默认模式
func preset_default() -> void:
	reset_defaults()
