import 'package:borderlessWorking/data/api/apis.dart';
import 'package:borderlessWorking/data/model/contact.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/dio.dart';
import 'apis.dart';
import 'package:dio/dio.dart';

class ApiService {
  static String mainUrl = Apis.mailURL;
  var loginUrl = mainUrl + Apis.login;
  var contactUrl = mainUrl + Apis.contact;
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  // Dio dio = Dio();
  final _dio = getDio();
  Future<bool> hasToken() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getToken() async {
    var token = await storage.read(key: 'token');
    if (token != null) {
      return token;
    }
  }

  Future<void> persistToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    storage.delete(key: 'token');
    storage.deleteAll();
  }

  //login
  Future<String> login(String email, String password) async {
    Response response = await _dio.post(loginUrl, data: {
      "email": email,
      "password": password,
    });
    return response.data["access_token"];
  }

  //getContact
  Future<List<ContactModel>> getContactLists() async {
    List<ContactModel> _dataList = [];
    Response response = await _dio.get(contactUrl);
    var body = (response.data);
    try {
      if (response.statusCode == 200) {
        for (var item in body['contacts']) {
          ContactModel data = new ContactModel.fromJson(item);
          _dataList.add(data);
        }
        return _dataList;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      //  return ContactModel.withError('asdfasdfasdfasdf');

    }
  }
}
