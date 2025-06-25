import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryItems {
  static Map<String, List<Map<String, String>>> categoryItems = {
    'News': [],
    'Religion': [],
    'Cartoon': [],
  };

  static Future<void> fetchData() async {
    final url = Uri.https(
      'gist.githubusercontent.com',
      '/arifulatwork/22a771aa1e054bca05dd0b620ac2612e/raw/tv.json',);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        data.forEach((key, value) {
          List<Map<String, String>> items = [];
          (value as List<dynamic>).forEach((item) {
            items.add({
              'image': item['image'],
              'text': item['text'],
              'videoUrl': item['videoUrl'],
            });
          });
          categoryItems[key] = items;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
