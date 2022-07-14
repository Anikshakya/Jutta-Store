import 'package:http/http.dart' as http;
import 'package:jutta_ghar/models/random_api_image.dart';

class JsonParseService {
  static const String url = 'https://jsonplaceholder.typicode.com/photos';

  static Future<List<RandomImage>> getData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        final List<RandomImage> albumData = randomImageFromJson(response.body);
        return albumData;
      } else {
        return <RandomImage>[];
      }
    } catch (e) {
      return <RandomImage>[];
    }
  }
}
