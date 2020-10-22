function initMap() {
    const map = new google.maps.Map(
        document.getElementById('google-maps-api-map'),
        {
            center: {
                lat: -34.53977,
                lng: -58.493954
            },
            zoom: 9
        }
    );

    
    console.log(window.locations);
    window.locations.forEach((location) => {
        console.log(location.latitude);
        var marker = new google.maps.Marker({
            position: {lat: parseFloat(location.latitude), lng: parseFloat(location.longitude)},
            map: map,
            title: location.name
        });
        var infowindow = new google.maps.InfoWindow({
            content: windowForLocation(location)
        })
        
        google.maps.event.addListener(marker, 'click', function(){
            infowindow.open(map, marker);
        });

        google.maps.event.addListener(marker, 'dblclick', function(){
            window.location.replace('locations/'+location.id)
        });
    });
}

function windowForLocation(location) {
    return `
        <h6>
            Nombre: `+ location.name +` <br>
            Dirección: `+ location.address +`  <br>
            Capacidad: `+ location.users_count +`/`+ location.capacity +`  <br>

        </h6>
    `;
}