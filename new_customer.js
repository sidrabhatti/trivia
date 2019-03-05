//This code opens the users native/default messaging application
//with prepopulated SMS copy that says 'TRIVIA' to a prepopulated number
document.addEventListener('DOMContentLoaded', function() {
  var gotoLink = '';
  var userAgent = navigator.userAgent || navigator.vendor || window.opera;
  var visible = false;
  var smsCopy = encodeURI("TRIVIA");



  if (/windows phone/i.test(userAgent)) {
    console.log("Windows Phone");
  } else if (/android/i.test(userAgent)) {
    console.log("Android");
    visible = true;
    gotoLink = "sms:727272?body=" + smsCopy;
  } else if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
    console.log("iOS");
    visible = true;
    gotoLink = "sms:727272&body=" + smsCopy;
  } else {
    console.log("unknown");
  }

  jQuery('.text-it').attr('href', gotoLink);

  if (!visible) {
    jQuery('.text-it').css('display', 'none');
  }

}, false);

$(function(){
  $('.text-it').on('click', function(e) {
    console.log("clicked");
    var smsCopy = $(e.currentTarget).attr('href');
    window.location.replace(smsCopy);
  });
});
