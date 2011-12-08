// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	$(".draggable").draggable({ revert: true });
	$(".droppable").droppable({
		drop: function( event, ui ) {
			var circle_id = $("a", this).attr("data-object-id");
			var person_id = ui.draggable.attr("data-object-id");
			var circle_name = $("a", this).text();
			var person_name = ui.draggable.attr("title");
      		$.post( "/ties", { "tie[circle_id]" : circle_id, "tie[contact_id]" : person_id } ).success(function() {
			  var text = person_name + " was added to your " + circle_name + " circle.";
			  $(".circle-info-message").html(text);
			  $(".circle-info-message").show();
			  setTimeout(function() {
				$(".circle-info-message").hide();
			  }, 5000)
		    });
		}
	});
});