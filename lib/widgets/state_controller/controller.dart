import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zylentrix_assi/widgets/components/api/api_adress.dart';
import 'package:zylentrix_assi/widgets/components/model/data_model_class.dart';

class ProviderStateController with ChangeNotifier {
  bool isLoading = true;
  List<DataModel> dataList = [];

  // this Function get api data. and After store searchResults variable inside
  Future<void> fetchData() async {
    try {
      final response = await get(Uri.parse(getUsersUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        dataList = data.map((json) => DataModel.fromJson(json)).toList();
        isLoading = false;
        notifyListeners();
      } else {
        // 200. if any code other than status code is received then this toast will be shown
        Fluttertoast.showToast(msg: "Api data Not Received");
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (e is SocketException) {
        // No internet connection error
        Fluttertoast.showToast(
          msg: "No Internet Connection",
        );
      } else if (e is TimeoutException) {
        // request timeout error
        Fluttertoast.showToast(
          msg: "Request Timed Out",
        );
      } else if (e is FormatException) {
        // Wrong data format error
        Fluttertoast.showToast(
          msg: "Invalid Response Format",
          toastLength: Toast.LENGTH_SHORT,
        );
      } else if (e is HttpException) {
        // API error
        Fluttertoast.showToast(
          msg: "Server Error: ${e.message}",
        );
      } else {
        // unknown error
        Fluttertoast.showToast(
          msg: "Something went wrong: ${e.toString()}",
        );
      }
    }
  }

  void rebuiled() {
    dataList.clear();
    isLoading = true;
    notifyListeners();
  }
}
