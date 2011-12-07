// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	$(".draggable").draggable({ revert: true });
	$(".droppable").droppable({
		drop: function( event, ui ) {
			var circle_id = $("a", this).attr("data-object-id");
			var person_id = ui.draggable.attr("data-object-id");
      		$.post( "/ties", { "tie[circle_id]" : circle_id, "tie[contact_id]" : person_id } ).success(function() {
			  ui.draggable.remove();
		    });
		}
	});
});