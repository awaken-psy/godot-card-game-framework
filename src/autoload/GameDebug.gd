## 游戏调试辅助 autoload
## 在 project.godot 中注册为单例，提供 MCP 热调入口
extends Node

## 手感调参器
var hand_feel: HandFeelTuner

## UI 测试器
var ui_tester: UIVisualTester


func _ready() -> void:
	# 初始化手感调参器
	hand_feel = HandFeelTuner.get_instance()
	ui_tester = UIVisualTester.get_instance()

	# 打印调试信息
	push_warning("[GameDebug] Ready. HandFeel params: %s" % hand_feel.dump_params())


## 快捷方法：调整手感参数
func tune(param_name: String, value: Variant) -> void:
	hand_feel.tune_param(param_name, value)


## 快捷方法：批量调整
func tune_batch(params: Dictionary) -> void:
	hand_feel.tune_batch(params)


## 快捷方法：获取当前参数
func get_params() -> String:
	return hand_feel.dump_params()


## 快捷方法：UI 节点位置检查
func check_ui(node_path: String, expected_x: float, expected_y: float) -> String:
	var result := ui_tester.check_node_position(node_path, {"x": expected_x, "y": expected_y})
	return JSON.stringify(result)


## 快捷方法：UI 可见性检查
func check_visible(node_path: String) -> String:
	var result := ui_tester.check_node_visible(node_path)
	return JSON.stringify(result)


## 快捷方法：捕获基线截图
func capture_baseline(name: String) -> String:
	return ui_tester.capture_baseline(name)


## 快捷方法：对比截图
func compare_ui(name: String) -> String:
	var result := ui_tester.capture_and_compare(name)
	return JSON.stringify(result)
