var map;
function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 1.3655744, lng: 103.8132874},
    zoom: 12
  });

  var marker = new google.maps.Marker({
    position: {lat: 1.3655744, lng: 103.8132874},
    map: map,
    title: 'Some Random Marker'
  });
  
  fetch('/clinics.json').then(function(r){ return r.json(); }).then(function(r){
    r.forEach(function(o){
      var loc = o.location;
      if(!loc.lat) return;

      console.log('location: ', loc);
      
      var marker = new google.maps.Marker({
        position: loc,
        map: map,
        title: o.clinic
      });
      
      var content = '<div>' 
        + '<h2>' + o.clinic + '</h2>'
        + '<p>' + o.address + '</p>'
        + '<div>' + '<strong>Opening Hours</strong>'
          + '<p>Monday - Friday: ' + o.operating_hours_mon___fri + '</p>'
          + '<p>Sat: ' + o.sat + '</p>'
          + '<p>Sun: ' + o.sun + '</p>'
        + '</div>'
        + '</div>' 
      var infowindow = new google.maps.InfoWindow({content: content});

      marker.addListener('click', function() {
        infowindow.open(map, marker);
      });
    });
  });
}

console.log('it works')
