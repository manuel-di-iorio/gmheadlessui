/// Events list
enum UIH_EVENTS {
	/// When the mouse moves over the element or its children
	mouse_move,
	
	/// When the mouse enters the element (but not triggered on its children)
	mouse_over,
	
	/// When the mouse enters the element or its children
	mouse_enter,
	
	/// When the mouse leaves the element or its children
	mouse_out,
	
	/// When the mouse is over the element and a mouse button is pressed
	mouse_down,
	
	/// When the mouse is over the element and a mouse button is released
	mouse_up,
	
	/// When the mouse is over the element and the left mouse button is released
	click,
}

/// Default handlers names
UIH_EVENTS_DEFAULT_HANDLERS = [
	"on_mouse_move",
	"on_mouse_over",	
	"on_mouse_enter",
	"on_mouse_out",
	"on_mouse_down",
	"on_mouse_up",
	"on_click",
];

/// Events phases
enum UIH_EVENTS_PHASE {
	capturing,
	bubbling,
	at_target
}

/**
 * Event struct
 *
 * @param {Real} _type
 * @param {Struct} _target
 */
function UihEvent(_type, _target) constructor {
	/**
	 * Event type
	 */
	 type = _type;
	
	/**
	 * Event initial target
	 */
	 target = _target;
	
	/**
	 * If the event is currently bubbling
	 */
	 bubbles = false;
	
	/**
	 * Event timestamp
	 */
	 event_phase = UIH_EVENTS_PHASE.capturing;
	
	/**
	 * If the event can continue to propagate
	 */
	 propagation = true;
	 
	 /**
	 * If the event can call the default handler of the component
	 */
	 defaultPrevented = false;
	
	/**
	 * Event timestamp
	 */
	timestamp = current_time;
	
	/**
	 * Stop the propagation of this event
	 */
	static stopPropagation = function() {
		propagation = false;
	}
	
	/**
	 * Prevent the default handler of the component to be called
	 */
	static preventDefault = function() {
		defaultPrevented = true;
	}
	
	/**
	 * Dispatch the event on the current target
	 */
	static dispatch = function() {
		var target_events = target.events;
		var target_event = target_events[$ type];
		
		// Call the component instance handler
		if (target_event) {		
			if (target_event.handler) target_event.handler(self);
				
			// Remove the handler if the event is set to be executed only once
			if (target_event.once) {
				variable_struct_remove(target_events, type);
			}
		}
				
		// Call the default handler (if not prevented from the component instance handler)
		if (!defaultPrevented) {
			var defaultHandlerName = global.UIH_EVENTS_DEFAULT_HANDLERS[type];
			var defaultHandler = target[$ defaultHandlerName];
			
			if (defaultHandler) {
				var boundDefaultHandler = method(target, defaultHandler);
				boundDefaultHandler(self);
			}
		}
	}
}

/**
 * Event settings struct
 *
 * @param {Function}  _handler Function to execute
 * @param {Bool}  _once If the listener has to be removed after the first execution
 * @param {Bool}  _captureOnly If the event will be executed only in the capturing phase
 */
function UihEventSettings( _handler,  _once,  _captureOnly) constructor {
	handler = _handler;
	once = _once;
	captureOnly = _captureOnly;
}