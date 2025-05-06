import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:spa_app/pages/branch/branch_detail.dart';
import 'package:spa_app/pages/home/profile_edit_dialog.dart';

import '../../services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  List<Map<String, dynamic>> branches = [];
  String uid = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchBranches();
  }

  Future<void> _fetchUserData() async {
    await FirebaseAuth.instance.currentUser?.reload();
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    uid = user.uid;
    try {
      final response = await http.get(
        Uri.parse('http://14.225.217.157:3002/users/$uid'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          userData = {"error": "Failed to load data"};
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userData = {"error": "Connection error"};
        isLoading = false;
      });
    }
  }

  Future<void> _fetchBranches() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final uid = user.uid;
  final url = Uri.parse('http://14.225.217.157:3002/branches/my-branches/?uid=$uid');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Kiểm tra và đảm bảo rằng 'branches' là một danh sách hợp lệ
      if (data['branches'] is List) {
        setState(() {
          branches = List<Map<String, dynamic>>.from(data['branches']);
          isLoading = false;
        });
      } else {
        print("❌ Dữ liệu chi nhánh không hợp lệ");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("❌ Lỗi lấy danh sách chi nhánh: ${response.body}");
      setState(() {
        isLoading = false;
      });
    }
  } catch (error) {
    print("❌ Lỗi kết nối: $error");
    setState(() {
      isLoading = false;
    });
  }
}


 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('images/bg_spa_2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Card(
            color: const Color(0xCCFFFFFF),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/logo_spa.jpg', // logo spa
                        height: 50,
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Trang quản lý Spa',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          await AuthService().signout(context: context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : userData == null
                          ? const Center(child: CircularProgressIndicator())
                          : userData!['error'] != null
                              ? Center(
                                  child: Text(
                                    userData!['error'] ?? 'Lỗi không xác định',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Hiển thị dialog để chỉnh sửa thông tin người dùng
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ProfileEditDialog(
                                                  uid: uid,
                                                  userData: userData!,
                                                );
                                              },
                                            ).then((updatedData) {
                                              if (updatedData != null) {
                                                setState(() {
                                                  userData = updatedData;  // Cập nhật lại dữ liệu người dùng
                                                });
                                              }
                                            });

                                          },
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.blue,
                                            child: Text(
                                              userData!['name'][0].toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userData!['name'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(userData!['email']),
                                          ],
                                        ),
                                      ],
                                    ),

                                      const SizedBox(height: 32),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Danh sách chi nhánh',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              showAddBranchDialog(context);
                                            },
                                            icon: const Icon(Icons.add),
                                            label: const Text('Thêm chi nhánh'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(child: _buildBranchList()),
                                    ],
                                  ),
                                ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildBranchList() {
  return ListView.builder(
    itemCount: branches.length,
    itemBuilder: (context, index) {
      final branch = branches[index];

      return Card(
        color: const Color(0xE6FFFFFF),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(branch['name'] ?? 'Chưa có tên'),
          subtitle: Text('${branch['address'] ?? 'Chưa có địa chỉ'} - ${branch['type'] ?? 'Chưa có loại'}'),
          onTap: () {
            // Khi nhấn vào chi nhánh, chuyển tới BranchDetailScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BranchDetailScreen(
                  branch: branch,  // Dữ liệu chi nhánh
                  userData: userData,  // Dữ liệu người dùng (có thể là null)
                ),
              ),
            );
          },
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Sửa thông tin chi nhánh nếu cần
            },
          ),
        ),
      );
    },
  );
}


void showAddBranchDialog(BuildContext context) {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  String selectedType = 'spa'; // mặc định là 'spa'

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Thêm chi nhánh'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên chi nhánh'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: const [
                  DropdownMenuItem(value: 'spa', child: Text('Spa')),
                  DropdownMenuItem(value: 'class', child: Text('Lớp học')),
                  DropdownMenuItem(value: 'warehouse', child: Text('Tổng kho')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedType = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Loại chi nhánh'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final address = addressController.text.trim();

              if (name.isEmpty || address.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
                );
                return;
              }

              await _createBranch(
                name: name,
                address: address,
                type: selectedType,
              );

              Navigator.pop(context); // đóng dialog sau khi thêm
            },
            child: const Text('Thêm'),
          ),
        ],
      );
    },
  );
}


Future<void> _createBranch({
  required String name,
  required String address,
  required String type,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("❌ Người dùng chưa đăng nhập!");
    return;
  }

  final uid = user.uid;
  final branchId = generateBranchId(uid);

  // Kiểm tra dữ liệu đầu vào
  if (name.isEmpty || address.isEmpty || type.isEmpty) {
    print("❌ Các trường thông tin không được để trống!");
    return;
  }

  final url = Uri.parse('http://14.225.217.157:3002/branches/add');
  final body = jsonEncode({
    "branch_id": branchId,
    "name": name,
    "address": address,
    "type": type,
    "created_by": uid,
  });

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    // Xử lý phản hồi từ server
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Tạo chi nhánh thành công!");
      _fetchBranches();
    } else {
      print("❌ Lỗi tạo chi nhánh: ${response.statusCode} - ${response.body}");
    }
  } catch (error) {
    // Xử lý lỗi nếu có lỗi kết nối hoặc lỗi khác
    print("❌ Lỗi kết nối: $error");
  }
}

String generateBranchId(String uid) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return "$uid-$timestamp";
}


}
