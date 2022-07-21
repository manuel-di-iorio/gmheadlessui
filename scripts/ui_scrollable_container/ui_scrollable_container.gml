/**
 * Get the render UI component 
 *
 * @param {Struct} initial_state Component initial state to store
 * @param {Struct} parent Parent layer. By default it is the root layer 
 *
 * @return {Struct}
 */
function UiScrollableContainer(initial_state, parent = undefined) : UihScrollableContainer(initial_state, parent) constructor {	
	draw = function() {		
		// Draw the background		
		draw_set_color(ui_variable_col_bg);
		draw_rectangle(0, 0, state.width, state.height, false);
	};
}