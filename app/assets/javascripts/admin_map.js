function initMap() {
    const map = new google.maps.Map(
        document.getElementById('google-maps-api-map'),
        {
            center: {
                lat: 46.231226,
                lng: 6.051737
            },
            zoom: 14
        }
    );

    const locations = [
        {lat: 46.233226, lng: 6.055737},
        {lat: 46.2278, lng: 6.0510},
        {lat: 46.23336, lng: 6.0471}
    ];
    locations.forEach((location) => {
        new google.maps.Marker({
            position: location,
            map: map
        });
    });
}