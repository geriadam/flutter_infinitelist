import 'dart:convert';
import 'package:flutter_infinitelist/models/comment.dart';
import 'package:http/http.dart' as http;
Future<List<Comment>> getCommentFromApi(int start, int limit) async {
  final url = "https://jsonplaceholder.typicode.com/comments?_start=$start&_limit=$limit";
  final http.Client httpClient = http.Client();
  try {
    final response = await httpClient.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      final List<Comment> comments = responseData.map((comment) {
        return Comment(
          id: comment['id'],
          name: comment['name'],
          email: comment['email'],
          body: comment['body']
        );
      }).toList();
      return comments;
    } else {
      return List<Comment>();
    }
  } catch(exception) {
    return List<Comment>();
  }
}