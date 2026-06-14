@tool
class_name HandFeelSettings
extends Resource

## 手感参数配置 - 可在运行时通过 MCP 热调
## 路径: res://settings/hand_feel.tres

## 卡牌移动动画时长（秒）
@export var card_move_duration: float = 0.25

## 卡牌聚焦缩放比例
@export var card_focus_scale: float = 1.15

## 卡牌聚焦动画时长
@export var card_focus_duration: float = 0.15

## 卡牌悬停延迟（毫秒）
@export var hover_delay_ms: int = 50

## 抽牌动画时长
@export var draw_duration: float = 0.3

## 弃牌动画时长
@export var discard_duration: float = 0.25

## 牌堆洗牌动画时长
@export var shuffle_duration: float = 0.6

## 格挡动画震动强度
@export var block_shake_intensity: float = 3.0

## 格挡动画震动频率
@export var block_shake_frequency: float = 8.0

## 格挡动画时长
@export var block_duration: float = 0.3

## 伤害数字弹出时长
@export var damage_popup_duration: float = 0.8

## 伤害数字弹出缩放
@export var damage_popup_scale: float = 1.5

## 缓动类型: 0=Linear, 1=In, 2=Out, 3=InOut
@export var ease_type: int = 2  # Tween.EASE_OUT

## 过渡类型: 0=Linear, 1=Sine, 2=Quint, 3=Expo, 4=Cubic
@export var trans_type: int = 2  # Tween.TRANS_QUINT


## 获取 Tween.EaseType 枚举值
func get_ease_type() -> int:
	return ease_type


## 获取 Tween.TransitionType 枚举值
func get_trans_type() -> int:
	return trans_type


## 从字典批量更新参数
func update_from_dict(params: Dictionary) -> void:
	for key in params.keys():
		if key in self:
			self[key] = params[key]
	emit_changed()


## 导出为 JSON 格式字典
func to_debug_dict() -> Dictionary:
	return {
		"card_move_duration": card_move_duration,
		"card_focus_scale": card_focus_scale,
		"card_focus_duration": card_focus_duration,
		"hover_delay_ms": hover_delay_ms,
		"draw_duration": draw_duration,
		"discard_duration": discard_duration,
		"shuffle_duration": shuffle_duration,
		"block_shake_intensity": block_shake_intensity,
		"block_shake_frequency": block_shake_frequency,
		"block_duration": block_duration,
		"damage_popup_duration": damage_popup_duration,
		"damage_popup_scale": damage_popup_scale,
		"ease_type": ease_type,
		"trans_type": trans_type,
	}
