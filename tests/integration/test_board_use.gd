extends "res://tests/UTcommon.gd"

class TestCardBoardDrop:
	extends "res://tests/Basic_common.gd"

	func test_card_table_drop_location_and_rotation_use_rectangle():
		cfc.game_settings.hand_use_oval_shape = false
		for c in cfc.NMAP.hand.get_all_cards():
			c.reorganize_self()
		await yield_for(0.5) # Wait to allow dragging to start
		# Reminder that card should not have trigger script definitions, to avoid
		# messing with the tests
		var card = cards[1]
		await drag_card(card, Vector2(450, 450))
		await move_mouse(Vector2(750, 300))
		drop_card(card,board._UT_mouse_position)
		await wait_card_tween(card, 0.5)
		assert_almost_eq(Vector2(750, 300),card.global_position,Vector2(2,2),
				"Card dragged in correct global position")
		card.card_rotation = 90
		await wait_card_tween(card, 0.5)
		assert_almost_eq(90.0,card.get_node("Control").rotation_degrees,2.0,
				"Card rotates 90")
		card.card_rotation = 180
		await wait_card_tween(card, 0.5)
		assert_almost_eq(180.0,card.get_node("Control").rotation_degrees,2.0,
				"Card rotates 180")
		card.set_card_rotation(180,false)
		await wait_card_tween(card, 0.5)
		assert_almost_eq(180.0,card.get_node("Control").rotation_degrees,2.0,
				"Card rotation doesn't revert without toggle")
		card.set_card_rotation(180,true)
		await wait_card_tween(card, 0.5)
		assert_almost_eq(0.0,card.get_node("Control").rotation_degrees,2.0,
				"Card rotation toggle works to reset to 0")
		assert_eq(2,card.set_card_rotation(111),
				"Setting rotation to an invalid value fails")
		assert_eq(2,cards[0].set_card_rotation(180),
				"Changing rotation to a card outside table fails")
		await move_mouse(card.global_position)
		assert_eq(1,card.set_card_rotation(270),
				"Rotation remained when card is focused")
		await drag_card(card, Vector2(1500, 150))
		assert_eq(270,card.card_rotation,
				"Rotation remains while card is being dragged")
		await move_mouse(cfc.NMAP.discard.position)
		drop_card(card,board._UT_mouse_position)
		await wait_card_tween(card, 0.5)
		await wait_card_tween(card, 0.5)
		assert_eq(0.0,card.get_node("Control").rotation_degrees,
				"Rotation reset to 0 while card is moving to hand")
		cfc.game_settings.hand_use_oval_shape = true

	func test_card_table_drop_location_use_oval():
		cfc.game_settings.hand_use_oval_shape = true
		# Reminder that card should not have trigger script definitions, to avoid
		# messing with the tests
		var card = cards[1]
		await table_move(card, Vector2(150, 300))
		card.card_rotation = 180
		await drag_drop(card, Vector2(600, 900))
		await wait_card_tween(card, 0.5)
		await wait_card_tween(card, 0.5)
		assert_almost_eq(-1.2,card.get_node("Control").rotation_degrees,2.0,
				"Rotation reset to a hand angle when card moved back to hand")
		cfc.game_settings.hand_use_oval_shape = true

	func test_fast_card_table_drop():
		# This catches a bug where the card keeps following the mouse after being dropped
		var card = cards[0]
		await drag_drop(card, Vector2(1050, 450))
		await move_mouse(Vector2(600, 300))
		await move_mouse(Vector2(1500, 750))
		assert_almost_eq(Vector2(1050, 450),cards[0].global_position,Vector2(2,2),
				"Card not dragged with mouse after dropping on table")

class TestDropRecovery:
	extends "res://tests/Basic_common.gd"

	func test_card_hand_drop_recovery():
		var card = cards[1]
		await drag_card(card, Vector2(150, 150))
		await move_mouse(Vector2(300, 930))
		drop_card(card,board._UT_mouse_position)
		await wait_card_tween(card, 0.5)
		await wait_card_tween(card, 0.5)
		assert_eq(hand.get_card_count(),5,
				"Card dragged back in hand remains in hand")

class TestBoardBorderBlock:
	extends "res://tests/Basic_common.gd"

	func test_card_drag_block_by_board_borders():
		var card = cards[4]
		await drag_card(card, Vector2(-150, 150))
		# Left border: card should not go past x=0
		assert_gt(card.global_position.x, -10,
				"Dragged outside left viewport borders stays inside viewport")
		await move_mouse(Vector2(1950, 450))
		# Right border: card + size*scale should not exceed viewport width
		var right_edge = card.global_position.x + card.canonical_size.x * card.scale.x
		assert_lt(right_edge, get_viewport().size.x + 5,
				"Dragged outside right viewport borders stays inside viewport")
		await move_mouse(Vector2(1200, -150))
		# Top border: card should not go above y=0
		assert_gt(card.global_position.y, -10,
				"Dragged outside top viewport borders stays inside viewport")
		await move_mouse(Vector2(750, 1200))
		# Bottom border: card + size*scale should not exceed viewport height
		var bottom_edge = card.global_position.y + card.canonical_size.y * card.scale.y
		assert_lt(bottom_edge, get_viewport().size.y + 5,
				"Dragged outside bottom viewport borders stays inside viewport")

class TestBoardToBoardMove:
	extends "res://tests/Basic_common.gd"


	func test_board_to_board_move():
		var card: Card
		card = cards[0]
		await table_move(card, Vector2(150, 300))
		card.card_rotation = 90
		await drag_drop(card, Vector2(1200, 300))
		assert_eq(90.0,card.get_node("Control").rotation_degrees,
				"Card should stay in the same rotation when moved around the board")

class TestBoardPause:
	extends "res://tests/Basic_common.gd"

	func test_pause():
		var card: Card
		card = cards[0]
		await table_move(card, Vector2(150, 300))
		await move_mouse(Vector2(0,0))
		cfc.game_paused = true
		await drag_drop(card, Vector2(1050, 450))
		assert_almost_eq(Vector2(150, 300),card.global_position,Vector2(2,2),
				"Card not moved while game paused")
		await move_mouse(deck.position + Vector2(10,10))
		for button in deck.get_all_manipulation_buttons():
			assert_eq(button.modulate[3],0.0)
		cfc.game_paused = false
		await drag_drop(card, Vector2(1050, 450))
		assert_almost_eq(Vector2(1050, 450),card.global_position,Vector2(5,5),
				"Game unpaused correctly")
