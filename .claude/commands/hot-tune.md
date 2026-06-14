---
description: MCP 热调手感参数
---

# 手感参数热调命令

## 读取当前参数
```
game_eval("return HandFeelTuner.get_instance().dump_params()")
```

## 调整单个参数
```
game_eval("HandFeelTuner.get_instance().tune_param('card_move_duration', 0.2)")
game_eval("HandFeelTuner.get_instance().tune_param('card_focus_scale', 1.2)")
```

## 批量调整参数
```
game_eval("HandFeelTuner.get_instance().tune_batch({'card_move_duration': 0.2, 'draw_duration': 0.25})")
```

## 应用预设
```
game_eval("HandFeelTuner.get_instance().preset_fast()")  # 快速模式
game_eval("HandFeelTuner.get_instance().preset_slow()")  # 慢动作模式
game_eval("HandFeelTuner.get_instance().preset_default()")  # 默认
```

## 保存配置
```
game_eval("HandFeelTuner.get_instance().save()")
```

## UI 回归测试

### 捕获基线
```
game_eval("UIVisualTester.get_instance().capture_baseline('combat_scene')")
```

### 对比当前与基线
```
game_eval("return JSON.stringify(UIVisualTester.get_instance().capture_and_compare('combat_scene'))")
```

### 检查节点位置
```
game_eval("return JSON.stringify(UIVisualTester.get_instance().check_node_position('/root/Main/Board/HPBar', {'x': 20, 'y': 20}))")
```

### 检查节点可见性
```
game_eval("return JSON.stringify(UIVisualTester.get_instance().check_node_visible('/root/Main/Board/SettingsButton'))")
```