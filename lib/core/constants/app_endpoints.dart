import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints{

  static final String BASE_URL = dotenv.get("BASE_URL");

}