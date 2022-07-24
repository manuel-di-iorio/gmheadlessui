/**
 * Render the component, updating its surface if necessary
 * 
 * @param {Array} updated_components Array containing the updated components; pass an empty-array variable to get all the updated components
 * @param {Array} children [Internal usage]
 * @param {Real} offset_x X offset to apply when drawing the component
 * @param {Real} offset_y Y offset to apply when drawing the component
 */
function ui_draw(updated_components = [], component = global.UIH_ROOT_COMPONENT, offset_x = 0, offset_y = 0) {
	// Store the drawing state (for later reset)
	var color = draw_get_color();
	var font = draw_get_font();
	var halign = draw_get_halign();
	var valign = draw_get_valign();
	var alpha = draw_get_alpha();
	
	if (!variable_struct_exists(component, "disable_surface") || !component.disable_surface) {
		var state = component.state;

		// If the surface has been deleted, force the re-rendering
		if (!surface_exists(component.surface)) {
			component.surface = surface_create(state.width + 1, state.height + 1);
			component.updated = true;
		}

		// Re-render the component on its surface if it has been updated
		if (component.updated) {
			// Set component surface as target
			surface_set_target(component.surface);
			draw_clear_alpha(c_black, 0);

			// Draw the component itself
			component.draw();

			// Draw each children on the component surface
			for (var i = 0, ilen = array_length(component.children); i < ilen; i++) {
				ui_draw(updated_components, component.children[i], -component.state.scroll_x, -component.state.scroll_y);
			}

			surface_reset_target();
			draw_set_alpha(1);
		}

		// Draw the component's surface on the current target surface
		draw_surface(component.surface, offset_x + component.state.x, offset_y + component.state.y);
	} else {
		// Draw each children on the current target surface adding component's offsets
		for (var i = 0, ilen = array_length(component.children); i < ilen; i++) {
			ui_draw(updated_components, component.children[i], offset_x + component.state.x - component.state.scroll_x, offset_y + component.state.y - component.state.scroll_y);
		}
	}

	// Reset the updated status of the component
    if (component.updated) {
        component.updated = false;
        array_push(updated_components, component);
    }

	// Reset the drawing state
	draw_set_color(color);
	draw_set_font(font);
	draw_set_halign(halign);
	draw_set_valign(valign);
	draw_set_alpha(alpha);
}
