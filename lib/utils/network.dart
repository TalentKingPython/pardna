import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pardna/utils/globals.dart' as globals;

class AuthService {
  static Future<http.Response> registerWithEmail(name, email, password) async {
    final baseURL = globals.baseURL;

    final response = await http.post(
      Uri.parse('$baseURL/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  static Future<http.Response> loginWithEmail(email, password) async {
    final baseURL = globals.baseURL;

    final response = await http.post(
      Uri.parse('$baseURL/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  static Future<http.Response> getProfile() async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.get(
      Uri.parse('$baseURL/auth/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }
}

class UserService {
  static Future<http.Response> getAllUnaddedTeamMembers() async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.get(
      Uri.parse('$baseURL/user/unmember'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  static Future<http.Response> getAllUsers() async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.get(
      Uri.parse('$baseURL/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  static Future<http.Response> addTeamMember(memberId) async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.post(
      Uri.parse('$baseURL/user/addmember'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
      body: jsonEncode(<String, String>{
        'member_id': memberId,
      }),
    );
    return response;
  }

  static Future<http.Response> getAllTeamMembers(members) async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.post(
      Uri.parse('$baseURL/user/members'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
      body: jsonEncode(<String, List>{
        'members': members,
      }),
    );
    return response;
  }

  static Future<http.Response> getAllAdminUsers() async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.get(
      Uri.parse('$baseURL/user/admin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  static Future<http.Response> getAllTier2Users() async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.get(
      Uri.parse('$baseURL/user/tier2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  static Future<http.Response> getAllTier1Users() async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.get(
      Uri.parse('$baseURL/user/tier1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  static Future<http.Response> setUserRoles(userId, roles) async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.post(
      Uri.parse('$baseURL/user/roles/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
      body: jsonEncode(<String, List>{
        'roles': roles,
      }),
    );
    return response;
  }
}

class ProjectService {
  static Future<http.Response> getAllProjects() async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.get(
      Uri.parse('$baseURL/project/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  static Future<http.Response> addNewProject(
      name, amount, number, start, duration) async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.post(
      Uri.parse('$baseURL/project/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
      body: jsonEncode(
        <String, String>{
          'name': name,
          'amount': amount,
          'number': number,
          'start': start,
          'duration': duration
        },
      ),
    );

    return response;
  }

  static Future<http.Response> deleteProject(projectId) async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.delete(
      Uri.parse('$baseURL/project/$projectId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  static Future<http.Response> addProjectMember(
      memberId, projectId, status) async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.post(
      Uri.parse('$baseURL/project/addmember'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
      body: jsonEncode(<String, String>{
        'member_id': memberId,
        'project_id': projectId,
        'status': status,
      }),
    );
    return response;
  }

  static Future<http.Response> getAllUnaddedProjectMembers(projectId) async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.get(
      Uri.parse('$baseURL/project/unmember/$projectId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  static Future<http.Response> getAllProjectMembers(projectId) async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.get(
      Uri.parse('$baseURL/project/member/$projectId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  static Future<http.Response> updateProjectMember(
      projectId, memberId, status) async {
    final baseURL = globals.baseURL;
    final authToken = globals.authToken;

    final response = await http.put(
      Uri.parse('$baseURL/project/member/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
      body: jsonEncode({
        'projectId': projectId,
        'memberId': memberId,
        'status': status,
      }),
    );

    return response;
  }
}
