// Default root layer component
global.UIH_ROOT_COMPONENT = new UihLayer({ x: 0, y: 0, width: room_width, height: room_height }, { 
	children: [],
	state: {
		scroll_x: 0,
		scroll_y: 0,
	},
	x_abs: function() {
		return 0;
	},
	y_abs: function() {
		return 0;
	},
	update: function() {},
	events: {},
});

/**
 * HEADLESS UI (Alpha)
 * Get the component struct
 *
 * @param {Struct} [ _state] Initial data to store into the component state
 * @param {Struct} [ _parent] Parent component
 *
 * @return {Struct}
 */
function UihComponent(
	_state = {},
	_parent = global.UIH_ROOT_COMPONENT
) constructor {
	state = _state;
	parent = _parent;
	
	/// Function called each tick to handle the component logic
	static step = undefined;
	
	/// Function called each tick to render the component
	static draw = undefined;

	/// When this component should skip the parent layer hovering checks
	skip_layer_checks = false;
	
	/// If to disable the component surface
	disable_surface = false;
	
	/// If the component state has been updated. This is automatically reset after the re-rendering
	updated = false;
	
	/// List of the child components
	children = [];
	
	/// Internal surface reference
	surface = noone;
	
	/// Map of events
	events = {};
	
	// Enhance the state with default values
	if (!variable_struct_exists(state, "x")) state.x = 0;
	if (!variable_struct_exists(state, "y")) state.y = 0;
	if (!variable_struct_exists(state, "width")) state.width = 0;
	if (!variable_struct_exists(state, "height")) state.height= 0;
	if (!variable_struct_exists(state, "scroll_x")) state.scroll_x = 0;
	if (!variable_struct_exists(state, "scroll_y")) state.scroll_y = 0;
	
	
	// Events setup
	if (variable_struct_exists(state, global.UIH_EVENTS_DEFAULT_HANDLERS[UIH_EVENTS.hover])) {
		set_event(UIH_EVENTS.hover, state.on_hover, false, true);
	}
	
	if (variable_struct_exists(state, global.UIH_EVENTS_DEFAULT_HANDLERS[UIH_EVENTS.click])) {
		set_event(UIH_EVENTS.click, state.on_click, false, true);
	}
			
	/**
	 * Update the component state, scheduling the element re-rendering. 
 	 * Note: The value change is sync, while the actual rendering is batched. 
 	 * Note: Re-rendering is scheduled only if the state has been actually been updated
	 *
	 * @param {Struct} [partialState] State keys to update
	 */
	static set = function(partialState = {}) {
		var names = variable_struct_get_names(partialState);
		for (var i=0, l=array_length(names); i<l; i++) {
			var name = names[i];
			if (state[$ name] != partialState[$ name]) {
				state[$ name] = partialState[$ name];
				update();
			}
		}
	};
	
	/**
	 * Set the component as updated and trigger the parent component update
	 */
	static update = function() {
		updated = true;
		parent.update();
	}
			
	/**
	 * Remove this component from the parent sorted children
	 */
	static remove = function() {
		var parentChildren = parent.children;
				
		// Find the parent sorted child to remove
		for (var i=0, len=array_length(parentChildren); i<len; i++) {
			if (parentChildren[i] == self) {
				array_delete(parentChildren, i, 1);
				break;
			}
		}
			
		// Destroy the surface
		if (surface_exists(surface)) {
			surface_free(surface);
		}
	};
		
	/**
	 * Resize the component surface
	 *
	 * @param {Real} width
	 * @param {Real} height
	 */
	static resize = function(width, height) {
		state.width = width;
		state.height = height;
			
		if (surface_exists(surface)) {
			surface_resize(surface, width + 1, height + 1);
		}

		update();
	};
		
	/**
	 * Get the X relative coordinate to the parent
	 *
	 * @return {Real}
	 */
	static x_abs = function() {
		return parent.x_abs() + state.x - parent.state.scroll_x;
	};
		 
	/**
	 * Get the Y relative coordinate to the parent
 	 * 
	 * @return {Real}
	 */
	static y_abs = function() {
		return parent.y_abs() + state.y - parent.state.scroll_y;
	};
	
	/**
	 * Add a component in the children list of this component
	 *
	 * @param {Struct} child Child component to add
	 */
	static add_child = function(child) {
		child.parent = self;
		array_push(children, child);
	};
	
	/**
	 * Set an handler for a specific event
	 *
	 * @param {Real} event Event type
	 * @param {Function} handler Function to execute
	 * @param {Bool} captureOnly If to run the event only at the capturing phase (false by default)
	 */
	static set_event = function(event, handler, once = false, captureOnly = false) {
		events[$ event] = new UihEventSettings(handler, once, captureOnly);
	};
	
	/**
	 * Remove an event
	 *
     * @param {Real} event Event type
	 */
	 static remove_event = function(event) {
		 variable_struct_remove(events, event);
	 }
	 
	 /**
	  * Dispatch the click event on the component
	  * TODO: Work in progress
	  */
	 static click = function() {
		 var event = new UihEvent(UIH_EVENTS.click, self);
		 event.event_phase = UIH_EVENTS_PHASE.at_target;
		 event.dispatch();
	 }
		
	// Store the new element into the parent children
	array_push(parent.children, self);
}
