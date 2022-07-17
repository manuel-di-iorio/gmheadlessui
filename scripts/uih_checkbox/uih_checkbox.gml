enum uih_enum_checkbox_status {
	idle,
	clicked,
	hover,
}

/**
 * Get the logical UI component 
 *
 * @param {Struct} state State to store in the component
 * @param {Struct} parent Parent layer. By default it is the root layer 
 * @param {Function} on_render Function called to render the component
 *
 * @return {Struct}
 */
function uih_checkbox(state = undefined, parent = undefined, on_render = undefined) {
	return uih_create_component({
		state: state, 
		parent: parent,
		on_render: on_render, 
		
		on_init: function(elem) {
			var state = elem.state;
			
			// Set the default checkbox status			
			state.status = uih_enum_checkbox_status.idle;
			
			state.type = variable_struct_exists(state, "type") ? state.type : ui_enum_variants.primary;
		},
		
		on_step: function(elem) {
			var elemState = elem.state;
			var status = elemState.status;
	
			if (status != uih_enum_checkbox_status.idle && mouse_check_button_released(mb_any)) {
				elem.set({ status: uih_enum_checkbox_status.idle });
			} else if (elem.parent.is_hovered(elem)) {
				if (mouse_check_button_pressed(mb_any)) {
					elem.set({ status: uih_enum_checkbox_status.clicked, checked: !elemState.checked });
					elem.click();
				} else if (status == uih_enum_checkbox_status.idle) {
					elem.set({ status: uih_enum_checkbox_status.hover });
				}
			} else if (status == uih_enum_checkbox_status.hover) {
				elem.set({ status: uih_enum_checkbox_status.idle });
			}
		}
	});
}
