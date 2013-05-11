// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function()
{
	// Add a qTip to all tooltip elements.
	$('.tooltip').each(function() {
		addTooltipSupport( $(this) );
	});
});

function addTooltipSupport( jQueryElement ) {

	jQueryElement.qtip({
		content: {
			text: 'Loading...',
			ajax: {
				url: jQueryElement.attr('href')
			},
		},
		style: {
			classes: 'qtip-tipsy'
		},
		position: {
			my: 'top center',
			at: 'bottom center'
		},
		show: {
			event: 'click',
			solo: true
		},
		hide: 'unfocus'
	});

	jQueryElement.click(function(event) {
		event.preventDefault();
	});

}
