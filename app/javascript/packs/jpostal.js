$(document).on('turbolinks:load', function() {
  $('#postal_code').jpostal({
    postcode: ['#postal_code'],
    address: {
      '#post_address': '%3%4%5'
    }
  });
});