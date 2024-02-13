import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class ClaimsController {
  //Load all Pc and locations
  Future<dynamic> getDoConfirmResons({
    required BuildContext context,
    required String com,
  }) async {
    Map data = {
      'com': com,
    };

    var getAllTypesAPI =
        "http://scm-stg.abans.com:1105/api/v1/SFA/Visitclaimtype";

    var response = await http.post(
      Uri.parse(getAllTypesAPI),
      body: data,
    );

    try {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body).cast<String, dynamic>();
        Logger().w(json);

        if (json['Success'] == true) {
          Logger().i("Successfully");
        } else {
          Logger().e("Success Failed");
        }
      } else {
        Logger().e("Status Code Error");
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }
}
