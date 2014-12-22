# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ajax:success', '#createParticipation', (xhr, data, status) -> 
location.reload()
$(document).on 'ajax:error', '#createParticipation', (xhr, data, status) ->
form = $('#new_participation .modal-body')
div = $('<div id="createParticipationErrors" class="alert alert-danger</div>')
ul = $('<ul></ul>')

if $('#createParticipationErrors')[0]
	$('#createParticipationErrors').html(ul)
else
	div.append(ul)
    form.prepend(div)

