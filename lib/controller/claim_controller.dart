import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../model/objects.dart';

class ClaimsController {
  //Load all Pc and locations
  Future<List<GetExpenseTypes>> getDoConfirmResons({
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
          List<GetExpenseTypes> claimTypes = json['Data']
              .map<GetExpenseTypes>((json) => GetExpenseTypes.fromJson(json))
              .toList();

          return claimTypes;
        } else {
          return Future.error("Success Failed");
        }
      } else {
        return Future.error("Status Code Error");
      }
    } catch (e) {
      Logger().e(e);
      return Future.error(e);
    }
  }
}
