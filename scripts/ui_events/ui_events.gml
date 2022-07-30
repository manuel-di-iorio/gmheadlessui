/**
 * Handle the components events
 */
function ui_events(component = global.UIH_ROOT_COMPONENT) {
	var parent = component.parent;
	var state = component.state;
	var children = component.children;
	var component_x = component.x_abs() + component.state.x - parent.state.scroll_x;
	var component_y = component.y_abs() + component.state.y - parent.state.scroll_y;
	var component_events= component.events;
	var component_event;
	var is_hovered = point_in_rectangle(mouse_x, mouse_y, component_x, component_y, component_x + state.width, component_y + state.height);
	
	// TODO: mouse_move must be triggered only if the mouse position changes and also need to check on the children
	if (is_hovered) {
		component_event = component_events[$ UIH_EVENTS.mouse_move];
		show_debug_message(component_event)
		if (component_event) {
			new UihEvent(UIH_EVENTS.mouse_move, component).dispatch();
		}
	}
	
	
	if (is_hovered && mouse_check_button_pressed(mb_left)) {
		component_event = component_events[$ UIH_EVENTS.click];
		if (component_event) {
			new UihEvent(UIH_EVENTS.click, component).dispatch();
		}
	}
	
	for (var i=0; i<array_length(children); i++) {
		ui_events(children[i]);
	}
}