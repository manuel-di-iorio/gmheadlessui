/**
 * Get the logical UI component 
 *
 * @param {String} id Component unique ID
 * @param {Struct} initialState Component initial state to store
 * @param {Struct} parent Parent layer. By default it is the root layer 
 * @param {Function} onInit Function called to enhance the initial state on component initialization
 *
 * @return {Struct}
 */
function uih_layer(id, initialState = undefined, parent = undefined, onInit = undefined) {
	return __uih_use_elem(id, initialState, parent, method({ onInit: onInit }, function(elem) {
		if (self.onInit != undefined) self.onInit(elem);
		
		/**
		 * Set the specified element as focused (if not already)
		 */
		elem.focus = method(elem, function(child) {
			var topIdx = array_length(self.sortedChildren) - 1;
			
			// Find the element to focus and move it on the top
			for (var i=topIdx; i>=0; i--) {
				var sortedChild = self.sortedChildren[i];
				if (sortedChild != child || sortedChild.skipLayerChecks) continue;
				if (i == topIdx) return;
				array_push(self.sortedChildren, child);
				array_delete(self.sortedChildren, i, 1);
				break;
			}
		});
		
		/**
		 * Check if the specified element is the most higher (on top) element, that is intersecting the mouse
		 */
		elem.is_hovered = method(elem,  function(elem) {
			for (var i=array_length(self.sortedChildren)-1; i>=0; i--) {
				var sortedChild = self.sortedChildren[i];
				if (sortedChild.skipLayerChecks) continue;
				var childX = sortedChild.state.x;
				var childY = sortedChild.state.y;
				if (!point_in_rectangle(mouse_x, mouse_y, childX, childY, childX + sortedChild.state.width, childY + sortedChild.state.height)) continue;
				return sortedChild == elem;
			}
			return undefined;
		});
	}), true);
}