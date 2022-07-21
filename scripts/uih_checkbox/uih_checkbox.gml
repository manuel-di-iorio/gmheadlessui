enum uih_enum_checkbox_status {
	idle,
	clicked,
	hover,
}

/**
 * Get the logical UI component 
 *
 * @param {Struct} initial_state State to store in the component
 * @param {Struct} parent Parent layer. By default it is the root layer
 *
 * @return {Struct}
 */
function UihCheckbox(initial_state = undefined, parent = undefined) : UihComponent(initial_state, parent) constructor {
	// Set the default checkbox status
	state.status = uih_enum_checkbox_status.idle;
	state.type = state[$ "type"] ?? ui_enum_variants.primary;
		
	step = function() {
		var status = state.status;

		if (status != uih_enum_checkbox_status.idle && mouse_check_button_released(mb_any)) {
			set({ status: uih_enum_checkbox_status.idle });
		} else if (parent.is_hovered(self)) {
			if (mouse_check_button_pressed(mb_any)) {
				set({ status: uih_enum_checkbox_status.clicked, checked: !state.checked });
				click();
			} else if (status == uih_enum_checkbox_status.idle) {
				set({ status: uih_enum_checkbox_status.hover });
			}
		} else if (status == uih_enum_checkbox_status.hover) {
			set({ status: uih_enum_checkbox_status.idle });
		}
	};
}
