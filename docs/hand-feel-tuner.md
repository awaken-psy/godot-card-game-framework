# 手感调参 + UI 回归系统

## 快速开始

### 1. 注册 GameDebug Autoload

在 `project.godot` 中添加：

```ini
[autoload]
GameDebug="*res://src/autoload/GameDebug.gd"
```

### 2. 启动游戏后使用 MCP 热调

```bash
# 读取当前参数
/hot-tune
```

---

## MCP 热调命令速查

### 手感参数

| 参数名 | 说明 | 默认值 |
|--------|------|--------|
| `card_move_duration` | 卡牌移动动画时长 | 0.25 |
| `card_focus_scale` | 卡牌聚焦缩放 | 1.15 |
| `card_focus_duration` | 聚焦动画时长 | 0.15 |
| `hover_delay_ms` | 悬停延迟 | 50 |
| `draw_duration` | 抽牌动画时长 | 0.3 |
| `discard_duration` | 弃牌动画时长 | 0.25 |
| `shuffle_duration` | 洗牌动画时长 | 0.6 |
| `block_shake_intensity` | 格挡震动强度 | 3.0 |
| `block_duration` | 格挡动画时长 | 0.3 |
| `damage_popup_duration` | 伤害数字时长 | 0.8 |

### 调参示例

```
# 单参数
game_eval("GameDebug.tune('card_move_duration', 0.2)")

# 批量
game_eval("GameDebug.tune_batch({'card_move_duration': 0.2, 'draw_duration': 0.25})")

# 预设
game_eval("HandFeelTuner.get_instance().preset_fast()")
```

---

## UI 回归测试

### 捕获基线

```
game_eval("GameDebug.capture_baseline('combat_scene')")
```

### 对比差异

```
game_eval("return GameDebug.compare_ui('combat_scene')")
```

### 检查节点位置

```
game_eval("return GameDebug.check_ui('/root/Main/Board/HPBar', 20, 20)")
```

---

## 文件结构

```
src/
├── autoload/
│   └── GameDebug.gd        # MCP 入口单例
├── settings/
│   ├── HandFeelSettings.gd # 参数定义
│   ├── HandFeelTuner.gd    # 热调逻辑
│   ├── UIVisualTester.gd   # 截图对比
│   └── hand_feel.tres      # 参数资源文件
```

---

## 集成到你的代码

在需要使用手感参数的地方：

```gdscript
# 获取参数
var settings := HandFeelTuner.get_instance().settings
var duration := settings.card_move_duration

# 应用到动画
var tween := create_tween()
tween.tween_property(card, "position", target_pos, duration)
```

监听参数变更：

```gdscript
HandFeelTuner.get_instance().register_callback(_on_settings_changed)

func _on_settings_changed(settings: HandFeelSettings) -> void:
	# 参数变了，重新应用
	card_move_duration = settings.card_move_duration
```
