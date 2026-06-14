## UI 视觉回归测试工具
## 通过 MCP 自动截图对比，检测 UI 偏移/布局问题
class_name UIVisualTester
extends RefCounted

## 截图保存目录
const SCREENSHOT_DIR := "res://screenshots/"

## 基线截图目录
const BASELINE_DIR := "res://screenshots/baseline/"

## 对比结果目录
const DIFF_DIR := "res://screenshots/diff/"

## 当前实例
static var _instance: UIVisualTester


## 获取单例
static func get_instance() -> UIVisualTester:
	if not _instance:
		_instance = UIVisualTester.new()
		_instance._ensure_dirs()
	return _instance


## 确保目录存在
func _ensure_dirs() -> void:
	# 在 Godot 运行时创建目录
	if not DirAccess.dir_exists_absolute(SCREENSHOT_DIR):
		DirAccess.make_dir_recursive_absolute(SCREENSHOT_DIR)
	if not DirAccess.dir_exists_absolute(BASELINE_DIR):
		DirAccess.make_dir_recursive_absolute(BASELINE_DIR)
	if not DirAccess.dir_exists_absolute(DIFF_DIR):
		DirAccess.make_dir_recursive_absolute(DIFF_DIR)


## MCP 入口：捕获当前屏幕作为基线
## 用法: game_eval("UIVisualTester.get_instance().capture_baseline('combat_scene')")
func capture_baseline(name: String) -> String:
	var path := BASELINE_DIR + name + ".png"
	_capture_screen(path)
	return "Baseline saved: " + path


## MCP 入口：捕获当前屏幕并与基线对比
## 用法: game_eval("UIVisualTester.get_instance().capture_and_compare('combat_scene')")
func capture_and_compare(name: String) -> Dictionary:
	var current_path := SCREENSHOT_DIR + name + "_current.png"
	var baseline_path := BASELINE_DIR + name + ".png"

	_capture_screen(current_path)

	if not ResourceLoader.exists(baseline_path):
		return {"error": "No baseline found", "current": current_path}

	var baseline := load(baseline_path) as Image
	var current := load(current_path) as Image

	if not baseline or not current:
		return {"error": "Failed to load images"}

	# 简单像素对比
	var result := _compare_images(baseline, current)
	result["current"] = current_path
	result["baseline"] = baseline_path

	return result


## 捕获屏幕到文件
func _capture_screen(path: String) -> void:
	var img := RenderingServer.viewport_get_texture(
		RenderingServer.get_rendering_device().get_viewport()
	).get_data()
	img.save_png(path)


## 简单像素对比
func _compare_images(img1: Image, img2: Image) -> Dictionary:
	if img1.get_size() != img2.get_size():
		return {
			"match": false,
			"reason": "Size mismatch",
			"size1": str(img1.get_size()),
			"size2": str(img2.get_size())
		}

	img1.convert(Image.FORMAT_RGBA8)
	img2.convert(Image.FORMAT_RGBA8)

	var data1 := img1.get_data()
	var data2 := img2.get_data()

	var diff_pixels := 0
	var total_pixels := img1.get_width() * img1.get_height()
	var threshold := 10  # RGB 差值阈值

	for i in range(0, data1.size(), 4):
		var r_diff := absi(data1[i] - data2[i])
		var g_diff := absi(data1[i + 1] - data2[i + 1])
		var b_diff := absi(data1[i + 2] - data2[i + 2])

		if r_diff > threshold or g_diff > threshold or b_diff > threshold:
			diff_pixels += 1

	var diff_percent := float(diff_pixels) / float(total_pixels) * 100.0

	return {
		"match": diff_percent < 1.0,  # 1% 以下差异视为匹配
		"diff_pixels": diff_pixels,
		"total_pixels": total_pixels,
		"diff_percent": snappedf(diff_percent, 0.01)
	}


## MCP 入口：列出所有已保存的基线
func list_baselines() -> Array:
	var files := []
	var dir := DirAccess.open(BASELINE_DIR)
	if dir:
		dir.list_dir_begin()
		var file := dir.get_next()
		while file != "":
			if not dir.current_is_dir() and file.ends_with(".png"):
				files.append(file.get_basename())
			file = dir.get_next()
	return files


## MCP 入口：删除指定基线
func delete_baseline(name: String) -> bool:
	var path := BASELINE_DIR + name + ".png"
	if ResourceLoader.exists(path):
		return DirAccess.remove_absolute(path) == OK
	return false


## 快捷测试：检测 UI 节点位置是否正确
## 用法: game_eval("UIVisualTester.get_instance().check_node_position('/root/Main/Board/HPBar', {'x': 20, 'y': 20})")
func check_node_position(node_path: String, expected: Dictionary) -> Dictionary:
	var node := get_node_or_null(NodePath(node_path))
	if not node:
		return {"error": "Node not found: " + node_path}

	var pos := node.global_position if "global_position" in node else node.position
	var expected_pos := Vector2(expected.get("x", 0), expected.get("y", 0))
	var diff := pos.distance_to(expected_pos)

	return {
		"node": node_path,
		"actual": {"x": pos.x, "y": pos.y},
		"expected": expected,
		"diff": diff,
		"match": diff < 5.0  # 5 像素误差以内
	}


## 快捷测试：检测节点是否可见
func check_node_visible(node_path: String) -> Dictionary:
	var node := get_node_or_null(NodePath(node_path))
	if not node:
		return {"error": "Node not found: " + node_path}

	var visible := true
	if "visible" in node:
		visible = node.visible
	if "modulate" in node:
		visible = visible and node.modulate.a > 0.01

	return {
		"node": node_path,
		"visible": visible,
		"match": visible
	}


## 辅助：安全获取节点
func get_node_or_null(path: NodePath) -> Node:
	var tree := Engine.get_main_loop() as SceneTree
	if tree and tree.root:
		return tree.root.get_node_or_null(path)
	return null
