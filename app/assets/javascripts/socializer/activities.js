// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function()
{
   $('.tooltip').each(function()
   {
	
      $(this).qtip(
      {
         content: {
            text: 'Loading...',
            ajax: {
               url: $(this).attr('href')
            },
         },
         style: {
		    classes: 'ui-tooltip-dark ui-tooltip-tipsy'
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
      })
   })
 
   // Make sure it doesn't follow the link when we click it
   .click(function(event) { event.preventDefault(); });
});