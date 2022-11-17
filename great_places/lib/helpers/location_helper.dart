const String GOOGLE_API_KEY = 'AIzaSyByAkQmSai6v8eAK6orkg7Td6_ttBge8Iw';

class LocationHelper {
  static String generateLocationPreviewImage({required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap'
    '&markers=color:red%7Clabel:C%7C$latitude,$longitude'
    '&key=$GOOGLE_API_KEY';
  }
}