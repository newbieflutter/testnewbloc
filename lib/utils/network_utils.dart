import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
//import 'package:orbitron/bloc/alarmlogs/api_bloc.dart';
import '../models/errors.dart';
import 'package:http/http.dart' as http;

class NetworkUtils {
  static const String host = 'http://192.168.1.1';

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static dynamic post(String url, Map body) async {
    var uri = host + '/test/' + url;
    Uri uriType = Uri.parse(uri);
    //print("uri is :" + uri);

    //var fullToken = 'Bearer $authToken';
    //print("fullToken send :" + authToken);
    //print("full body send:" + json.encode(body));
    try {
      bool trustSelfSigned = false;
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => trustSelfSigned);
      IOClient ioClient = IOClient(httpClient);

      final response = await ioClient.post(uriType,
          headers: {
            //'Authorization': fullToken,
            'Content-type': 'application/json'
          },
          body: json.encode(body));
      final code = response.statusCode;

      if (code == 401) {
        //print("About to throw 401");
        return Future.error(
            AuthError('$code Auth Error: ' + parseMessage(response.body)));
      } else if (code >= 500) {
        return Future.error(UnknownError(
            '$code Unknown Error: ' + parseMessage(response.body)));
      } else if (code >= 400) {
        //print("Future error first catch is Error4xxx" + code.toString());
        return Future.error(
            Error4xx('$code Error4xxx: ' + parseMessage(response.body)));
      }
      if (url == "shareLink") {
        return parseLink(response.body);
      } else {
        return response.body;
      }
    } catch (exception) {
      print("MAIN exception" + exception.toString());
      if (exception.toString().contains('SocketException')) {
        return Future.error(UnknownError('Network error: check connection'));
      } else {
        return Future.error(UnknownError(exception.toString()));
        //throw exception;
      }
    }
  }

  static parseMessage(String body) {
    var message;
    try {
      //var x = json.decode(body) as Map<String, dynamic>;
      //decodeSucceeded = true;
      try {
        final responseJson = json.decode(body);

        if (responseJson != null) {
          message = responseJson['error'];
          return message ?? "";
        }
      } catch (err) {
        //print("couldn't extract err message from ${body ?? 'null'}");
        return "Error";
      }
      return 'error was: $body';
    } on FormatException catch (e) {
      return "Error";
    }
  }

  static parseStatus(String body) {
    var message;
    try {
      final responseJson = json.decode(body);

      if (responseJson != null) {
        message = responseJson['message'];
        return message ?? "";
      }
    } catch (err) {
      //print("couldn't extract err message from ${body ?? 'null'}");
    }
    return 'error was: $body';
  }

  static parseLink(String body) {
    var message;
    try {
      final responseJson = json.decode(body);

      if (responseJson != null) {
        message = responseJson['Success'];
        return message ?? "";
      }
    } catch (err) {
      //print("couldn't extract err message from ${body ?? 'null'}");
    }
    return 'error was: $body';
  }
}
