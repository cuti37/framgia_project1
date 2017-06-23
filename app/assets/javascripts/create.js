// $("#new_comment").submit(function(event) {
//   $.ajax({
//     event.preventDefault();
//     var $(this) = $("#new_comment");
//     var params = $(this).serialize();
//     url: $(this).attr("action"),
//     type: 'POST',
//     dataType: 'json',
//     data: {comment: params},
//   })
//   .done(function(response) {
//     if(response.status == 'success'){
//       alert(response.html())
//     }else{
//       alert(response.html())
//     }
//   })
//   .fail(function() {
//     console.log("error");
//   })
//   .always(function() {
//     console.log("complete");
//   });

//   /* Act on the event */
// });
