# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Override Rails handling of confirmation

# Override Rails handling of confirmation

$.rails.allowAction = (element) ->
  # The message is something like "Are you sure?"
  message = element.data('confirm')
  # If there's no message, there's no data-confirm attribute, 
  # which means there's nothing to confirm
  return true unless message
  # Clone the clicked element (probably a delete link) so we can use it in the dialog box.
  $link = element.clone()
    # We don't necessarily want the same styling as the original link/button.
    .removeAttr('class')
    # We don't want to pop up another confirmation (recursion)
    .removeAttr('data-confirm')
    # We want a button
    .addClass('btn').addClass('btn-danger')
    # We want it to sound confirmy
    .html("Delete")

  # Create the modal box with the message
  modal_html = """
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-exclamation-triangle"></i> Warning</h4>
      </div>
      <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
      <div class="modal-body">
        <h3>Are you sure?</h3>
        <p>#{message}</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
               """
  $modal_html = $(modal_html)
  # Add the new button to the modal box
  $modal_html.find('.modal-footer').append($link)
  # Pop it up
  $modal_html.modal()
  # Prevent the original link from working
  return false