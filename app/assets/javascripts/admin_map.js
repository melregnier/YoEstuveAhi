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
        new google.maps.Marker({
            position: {lat: parseFloat(location.latitude), lng: parseFloat(location.longitude)},
            map: map
        });
    });
}