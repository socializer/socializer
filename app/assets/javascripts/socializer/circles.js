// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	$(".draggable").draggable({ revert: true });
	$(".droppable").droppable({
		drop: function( event, ui ) {
			
			var circle = $("a", this);
			var person = ui.draggable;
			var circle_id = circle.attr("data-object-id");
			var person_id = person.attr("data-object-id");
			var circle_name = circle.text();
			var person_name = $("img", person).attr("oldtitle");
			var circle_tie_count = $(".circle-tie-count", this)
			
      		$.post( "/ties", { "tie[circle_id]" : circle_id, "tie[contact_id]" : person_id } ).success(function() {
	
			  var tie_count = parseInt(circle_tie_count.html()) + 1;
	          circle_tie_count.html(tie_count.toString())
	
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