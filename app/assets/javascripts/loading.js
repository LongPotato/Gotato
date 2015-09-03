$( document ).ready(function() {

$( ".trigger-click" ).click(function() {
  $('#loadingModal').modal('show');
  $.ajax({ url: "http://localhost:3000/users/3/report", success: function (data) 
          { $('#loadingModal').modal('hide');
            console.log('The page has been successfully loaded');
          }, error: function () {
                    $('#loadingModal').modal('hide');
                    console.log('An error occurred'); }
         });
    });
    
});