/**
 * Handle the components events
 */
function ui_events(component = global.UIH_ROOT_COMPONENT) {
	var parent = component.parent;
	var state = component.state;
	var children = component.children;
	var component_x = component.x_abs() - parent.state.scroll_x;
	var component_y = component.y_abs() - parent.state.scroll_y;
	var events = component.events;
	var event;
	var is_hovered = point_in_rectangle(mouse_x, mouse_y, component_x, component_y, component_x + state.width, component_y + state.height);
	
	if (is_hovered) {
		event = events[$ UIH_EVENTS.hover];
		if (event) {
			new UihEvent(UIH_EVENTS.hover, component).dispatch();
		}
	}
	
	if (is_hovered && mouse_check_button_released(mb_left)) {
		event = events[$ UIH_EVENTS.click];
		if (event) {
			new UihEvent(UIH_EVENTS.click, component).dispatch();
		}
	}
	
	for (var i=0; i<array_length(children); i++) {
		ui_events(children[i]);
	}
}