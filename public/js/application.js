$(document).ready(function() {
  $('.loading').hide();
  $('#tweeter_form').on('submit', function(event) {
    $('.tweets').empty();
    event.preventDefault();
    $('.loading').show();
    $.get('/' + $('input[name="tweeter"]').val(), function(tweetData) {
      $('.loading').hide();
      $('.tweets').html(tweetData);
    });
  });
  $('#tweet-from').on('submit', function(event) {
    $('.tweets').empty();
    event.preventDefault();
    $.post('/tweets/new', $(this).serialize(), function() {
      $('input[name="tweet"]').val("");
      $('.tweets').append('<p>Tweet Sent!</p>');
    });
  });
});
