function CallServerFunction() {
  $('#loadingModal').modal('show');
  $.ajax({ url: "", success: function (data) 
          { $('#loadingModal').modal('hide');
            console.log('The page has been successfully loaded');
          }, error: function () {
                    $('#loadingModal').modal('hide');
                    console.log('An error occurred'); }
         });
}