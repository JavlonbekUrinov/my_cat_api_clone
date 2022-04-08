import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:my_cat_api_clone/models/breed_model.dart';
import 'package:my_cat_api_clone/models/cat_model.dart';
import 'log_service.dart';

class Network {
  /// Set isTester ///
  static bool isTester = false;

  /// Servers Types ///
  static String SERVER_DEVELOPMENT = "api.thecatapi.com";
  static String SERVER_PRODUCTION = "api.thecatapi.com";

  /// * Http Apis *///
  static String API_LIST = "/v1/images/search";
  static String API_LIST_Breeds = "/v1/breeds";
  static String API_UPLOAD = "/v1/images/upload";
  static String API_GET_UPLOADS = "/v1/images/";

  // static String API_SEARCH_PHOTOS = '/search/photos';

  /// Getting Header ///
  static Map<String, String> getHeaders() {
    Map<String, String> header = {
      "x-api-key": "44396f00-74f3-4c52-8603-c3268fe5d6a9",
      "Content-Type": "application/json",
    };
    return header;
  }

  static Map<String, String> getUploadHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'x-api-key': '44396f00-74f3-4c52-8603-c3268fe5d6a9'
    };
    return headers;
  }

  /// Selecting Test Server or Production Server  ///

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  ///* Http Requests *///

  /// GET method///
  static Future<String?> GET(String api, Map<String, String> params) async {
    Uri uri = Uri.https(getServer(), api, params);
    Response response = await get(uri, headers: getHeaders());
    Log.i(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /// POST method///
  static Future<String?> POST(String api, String filePath, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api);
    var request = MultipartRequest('POST', uri);
    request.headers.addAll(getUploadHeaders());
    request.files.add(await MultipartFile.fromPath('file', filePath,
        contentType: MediaType("image", "jpeg")));
    request.fields.addAll(params);
    StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }

  /// DELETE method ///

  /// DELETE ///
  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri,headers: getHeaders());
    Log.e(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }


  /// * Http Params * ///

  /// GET PARAM
  static Map<String, String> paramsGet(int page) {
    Map<String, String> params = {
      'limit': '10',
      'page': '$page',
      'order': 'DESC',
    };
    return params;
  }

  ///  CATEGORY PARAM
  static Map<String, String> paramsCategoryGet(int page, int id) {
    Map<String, String> params = {
      'limit': '10',
      'page': '$page',
      'category_ids': '$id',
      'order': 'Desc',
    };
    return params;
  }

  /// PARAM EMPTY
  static Map<String, String> paramEmpty() {
    Map<String, String> params = {};
    return params;
  }

  ///  PARAM SEARCH
  static Map<String, String> paramSearch(String id, int page) {
    Map<String, String> params = {
      'limit': '10',
      'page': '$page',
      'breed_ids': id,
    };
    return params;
  }

  /// * PARSING * ///

  static List<Cat> parseCatList(String response) {
    var data = catListFromJson(response);
    return data;
  }

  static List<Breeds> parseBreedsList(String response) {
    var data = breedsListFromJson(response);
    return data;
  }

  static List<Breeds> parseSearch(String response) {
    var data = breedsListFromJson(response);
    return data;
  }
}
