extends "res://tests/UTcommon.gd"

class TestSingleCardFocus:
	extends "res://tests/Basic_common.gd"

	func test_single_card_focus_use_rectangle():
		cfc.game_settings.hand_use_oval_shape = false
		cards[0]._on_Card_mouse_entered()
		await wait_card_tween(cards[0])
		assert_almost_eq(Vector2(66.75, -360),cards[0].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(Vector2(2.25, 2.25),cards[0].scale,Vector2(0.15, 0.15),
				"Card has correct scale")
		cards[0]._on_Card_mouse_exited()
		await wait_card_tween(cards[0])
		assert_almost_eq(cards[0].recalculate_position(),cards[0].position,Vector2(2,2),
				"Card placed in correct global position")
		assert_almost_eq(Vector2(1, 1),cards[0].scale,Vector2(0.15, 0.15),
				"Card has correct scale")
		cfc.game_settings.hand_use_oval_shape = true

	func test_single_card_focus_use_oval():
		cfc.game_settings.hand_use_oval_shape = true
		cards[0]._on_Card_mouse_entered()
		await wait_card_tween(cards[0])
		assert_almost_eq(Vector2(154.5, -360),cards[0].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(Vector2(2.25, 2.25),cards[0].scale,Vector2(0.15, 0.15),
				"Card has correct scale")
		cards[0]._on_Card_mouse_exited()
		await wait_card_tween(cards[0])
		assert_almost_eq(cards[0].recalculate_position(),cards[0].position,Vector2(2,2),
				"Card placed in correct global position")
		assert_almost_eq(Vector2(1, 1),cards[0].scale,Vector2(0.15, 0.15),
				"Card has correct scale")
		cfc.game_settings.hand_use_oval_shape = true

class TestNeightbourPush:
	extends "res://tests/Basic_common.gd"

	func test_card_focus_neighbour_push_use_rectangle():
		cfc.game_settings.hand_use_oval_shape = false
		cards[2]._on_Card_mouse_entered()
		await yield_for(1)
		assert_almost_eq(Vector2(38.62, 0),cards[0].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(Vector2(201.75, 0),cards[1].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(Vector2(1034.25, 0),cards[3].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(Vector2(1197.38, 0),cards[4].position,Vector2(2,2),
				"Card dragged in correct global position")
		cfc.game_settings.hand_use_oval_shape = true
	func test_card_focus_neighbour_push_use_oval():
		cfc.game_settings.hand_use_oval_shape = true
		cards[2]._on_Card_mouse_entered()
		await yield_for(1)
		assert_almost_eq(Vector2(154.08, -33.59),cards[0].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(Vector2(270, -60),cards[1].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(Vector2(965.25, -60),cards[3].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(Vector2(1083, -33.75),cards[4].position,Vector2(2,2),
				"Card dragged in correct global position")
		cfc.game_settings.hand_use_oval_shape = true

class TestChangeFocusNeighbour:
	extends "res://tests/Basic_common.gd"

	func test_card_change_focus_to_neighbour():
		var YIELD_TIME := 0.07
		var YIELD_TIME2 := 0.5
		cards[2]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME)
		cards[2]._on_Card_mouse_exited()
		cards[3]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME)
		cards[3]._on_Card_mouse_exited()
		cards[4]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME2)
		cards[4]._on_Card_mouse_exited()
		cards[3]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME)
		cards[3]._on_Card_mouse_exited()
		cards[2]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME)
		cards[2]._on_Card_mouse_exited()
		cards[1]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME2)
		cards[1]._on_Card_mouse_exited()
		cards[0]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME2)
		cards[0]._on_Card_mouse_exited()
		await wait_card_tween(cards[0])
		assert_almost_eq(cards[0].recalculate_position(),
				cards[0].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(cards[1].recalculate_position(),
				cards[1].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(cards[2].recalculate_position(),
				cards[2].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(cards[3].recalculate_position(),
				cards[3].position,Vector2(2,2),
				"Card dragged in correct global position")
		assert_almost_eq(cards[4].recalculate_position(),
				cards[4].position,Vector2(2,2),
				"Card dragged in correct global position")

class TestHandCardSlide:
	extends "res://tests/Basic_common.gd"

	func test_card_hand_mouseslide():
		var YIELD_TIME := 0.02
		cards[0]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME)
		cards[0]._on_Card_mouse_exited()
		await yield_for(YIELD_TIME)
		cards[1]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME)
		cards[2]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME)
		cards[1]._on_Card_mouse_exited()
		await yield_for(YIELD_TIME)
		cards[3]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME)
		cards[2]._on_Card_mouse_exited()
		await yield_for(YIELD_TIME)
		cards[4]._on_Card_mouse_entered()
		await yield_for(YIELD_TIME)
		cards[3]._on_Card_mouse_exited()
		await yield_for(YIELD_TIME)
		#cards[4]._on_Card_mouse_entered()
		await wait_card_tween(cards[4])
		assert_eq(cards[4].state,Card.CardState.FOCUSED_IN_HAND, "Card is Focused")
