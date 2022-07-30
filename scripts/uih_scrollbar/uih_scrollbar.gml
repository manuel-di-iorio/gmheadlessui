enum uih_enum_scrollbar_status {
	idle,
	hover,
	dragging,
}

enum uih_enum_scrollbar_direction {
	vertical,
	horizontal,
}


/**
 * Get the logical UI component 
 *
 * @param {Struct} _state Initial state to store in the component
 * @param {Struct} _parent Parent layer. By default it is the root layer
 *
 * @return {Struct}
 */
function UihScrollbar(_state = undefined, _parent = undefined) : UihComponent(_state, _parent) constructor {
	// Set the default scrollbar status
	state.type = state[$ "type"] ?? ui_enum_variants.primary;
	state.status = uih_enum_button_status.idle;
	state.direction = state[$ "direction"] ?? uih_enum_scrollbar_direction.vertical;
	state.value = state[$ "value"] ?? 0;
	state.thumb_size = state[$ "thumb_size"] ?? 0;

	static step = function() {
		var status = state.status;
		var hovered = parent.is_hovered(self);
		
		if (status != uih_enum_scrollbar_status.idle && mouse_check_button_released(mb_any)) {
			set({ status: uih_enum_scrollbar_status.idle });
		} else if ((hovered && mouse_check_button_pressed(mb_any)) || state.status == uih_enum_scrollbar_status.dragging) {
			// Update value if mouse pressed on scrollbar or if it is already being dragged
			var mouse_delta = state.direction == uih_enum_scrollbar_direction.vertical
				? mouse_y - state.thumb_size / 2 - state.y
				: mouse_x - state.thumb_size / 2 - state.x;
			var track_length = state.direction == uih_enum_scrollbar_direction.vertical
				? state.height - state.thumb_size
				: state.width - state.thumb_size;
			var value = clamp(mouse_delta / track_length, 0, 1);
			
			set({ 
				status: uih_enum_scrollbar_status.dragging, 
				value: value,
			});
			
			if (variable_struct_exists(state, "on_change")) {
				state.on_change(value);
			}
		} else if (hovered) {
			if (status != uih_enum_scrollbar_status.hover) {
				set({ status: uih_enum_scrollbar_status.hover });	
			}
		} else if (status != uih_enum_scrollbar_status.idle) {
			set({ status: uih_enum_scrollbar_status.idle });
		}
	};
}