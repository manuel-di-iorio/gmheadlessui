/**
 * Get the render UI component 
 *
 * @param {Struct} initial_state Component initial state to store
 * @param {Struct} parent Parent layer. By default it is the root layer 
 *
 * @return {Struct}
 */
function UiScrollbar(initial_state, parent = undefined) : UihScrollbar(initial_state, parent) constructor {	
	draw = function() {		
		// Draw the track
		var bgcolor = state.type == ui_enum_variants.primary ? ui_variable_col_primary_dark : ui_variable_col_secondary_dark;
		
		draw_set_color(bgcolor);
		draw_rectangle(0, 0, state.width, state.height, false);
		
		// Draw the thumb
		var thumb_x1, thumb_y1, thumb_x2, thumb_y2;
		if (state.direction == uih_enum_scrollbar_direction.vertical) {
			thumb_x1 = 0;
			thumb_y1 = (state.height - state.thumb_size) * state.value;
			thumb_x2 = state.width;
			thumb_y2 = thumb_y1 + state.thumb_size;
		} else {
			thumb_x1 = (state.width - state.thumb_size) * state.value;
			thumb_y1 = 0;
			thumb_x2 = thumb_x1 + state.thumb_size;
			thumb_y2 = state.height;
		}
			
		var thumb_color;
		switch (state.status) {
			case uih_enum_scrollbar_status.dragging:
				thumb_color = state.type == ui_enum_variants.primary ? ui_variable_col_primary_light : ui_variable_col_secondary_light;
				break;
			default: 
				thumb_color = state.type == ui_enum_variants.primary ? ui_variable_col_primary : ui_variable_col_primary;
		}
		
		draw_set_color(thumb_color);
		draw_rectangle(thumb_x1, thumb_y1, thumb_x2, thumb_y2, false);
	};
}