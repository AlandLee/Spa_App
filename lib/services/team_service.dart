import 'dart:convert';
import 'package:http/http.dart' as http;

class TeamService {
  static const String baseUrl = "http://14.225.217.157:3002";

  // Lấy danh sách team
  static Future<List<Map<String, dynamic>>> fetchTeams(String uid) async {
    final response = await http.get(Uri.parse("$baseUrl/teams?uid=$uid"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Failed to load teams");
    }
  }

  // Tạo team mới
  static Future<void> createTeam({
    required String teamId,
    required String name,
    required String ownerUid,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/teams/create"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "team_id": teamId,
        "name": name,
        "owner_uid": ownerUid,
        "members": jsonEncode([
          {"uid": ownerUid, "role": "admin"} // Thêm owner vào members với role
        ])
      }),
    );

    if (response.statusCode != 200) {
      final errorMessage = json.decode(response.body)['error'] ?? 'Unknown error';
      print("Error Response: $errorMessage"); // In lỗi ra console
      throw Exception("Failed to create team: $errorMessage");
    }
  }

  // Thêm thành viên vào team
  static Future<void> addMember(String teamId, String memberUid, String role) async {
    final response = await http.post(
      Uri.parse("$baseUrl/teams/$teamId/addMember"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "member_uid": memberUid,
        "role": role // Thêm role khi thêm thành viên
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add member to team");
    }
  }

  // Xóa team
  static Future<void> deleteTeam(String teamId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/teams/$teamId/delete"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete team");
    }
  }
}
