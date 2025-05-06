import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spa_app/services/entity_local_service.dart';

class EntityScreen extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const EntityScreen({super.key, required this.branch, required this.userData});

  @override
  State<EntityScreen> createState() => _EntityScreenState();
}


class _EntityScreenState extends State<EntityScreen> {
  final List<Map<String, dynamic>> entities = [
  {
    'type': 'Khách hàng',
    'code': 'KH1',
    'name': 'Nguyễn Văn A',
    'phone': '0901234567',
    'email': 'vana@example.com',
    'gender': 'Nam',
    'cccd': '123456789012',
    'hometown': 'Hà Nội',
    'dob': '01/01/1990',
    'start_date': '01/01/2022',
    'end_date': '31/12/2025',
    'position': ['Khách hàng'], // Dạng danh sách
  },
  {
    'type': 'Học viên',
    'code': 'HV2',
    'name': 'Trần Thị B',
    'phone': '0909876543',
    'email': 'thib@example.com',
    'gender': 'Nữ',
    'cccd': '987654321098',
    'hometown': 'TP.HCM',
    'dob': '15/03/1992',
    'start_date': '01/06/2021',
    'end_date': '31/12/2024',
    'position': ['Học viên'], // Dạng danh sách
  },
  {
    'type': 'Giáo viên',
    'code': 'GV3',
    'name': 'Lê Văn C',
    'phone': '0911122233',
    'email': 'vanc@example.com',
    'gender': 'Nam',
    'cccd': '456789123456',
    'hometown': 'Đà Nẵng',
    'dob': '20/05/1988',
    'start_date': '01/03/2020',
    'end_date': '31/12/2023',
    'position': ['Giáo viên', 'Trợ giảng'], // Dạng danh sách đúng
  },
  {
    'type': 'Khách hàng',
    'code': 'KH4',
    'name': 'Phạm Thị D',
    'phone': '0933445566',
    'email': 'thid@example.com',
    'gender': 'Nữ',
    'cccd': '321654987654',
    'hometown': 'Cần Thơ',
    'dob': '10/10/1995',
    'start_date': '01/08/2022',
    'end_date': '31/12/2025',
    'position': ['Khách hàng'], // Dạng danh sách
  },
];

  bool isDeleteMode = false;
  Set<int> selectedRows = {}; 
  bool selectAll = false;
  int birthdayCount = 0;
  int birthdayMonth = 1;
  String searchName = ''; 
  List<Map<String, dynamic>> filteredEntities = [];
  final TextEditingController birthdayMonthController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    birthdayCount = countBirthdays(entities, birthdayMonth);
    filteredEntities = List.from(entities);
    //fetchEntitiesByBranch(widget.branch['branch_id'].toString());
    fetchEntitiesByBranchFromSQLite(widget.branch['branch_id'].toString());
  }

  Future<void> fetchEntitiesByBranch(String branchId) async {
  final url = Uri.parse('http://14.225.217.157:3002/entities/by-branch/$branchId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    print('Dữ liệu nhận được: $data');

    setState(() {
      entities.clear();
      entities.addAll(data.map((item) {
        final entity = item as Map<String, dynamic>;

        final rawPosition = entity['position'];
        if (rawPosition != null) {
          try {
            dynamic decoded = rawPosition;

            if (rawPosition is String) {
              decoded = jsonDecode(rawPosition);
              if (decoded is String) {
                decoded = jsonDecode(decoded); // decode lần 2 nếu cần
              }
            }

            if (decoded is List) {
              entity['position'] = decoded.map((e) => e.toString()).toList();
              print('Entity ${entity['id']} position parsed: ${entity['position']}');
            } else {
              print('Entity ${entity['id']} position không phải List sau decode.');
              entity['position'] = <String>[];
            }
          } catch (e) {
            print('Lỗi khi parse position: $e');
            entity['position'] = <String>[];
          }
        } else {
          entity['position'] = <String>[];
        }

        return entity;
      }).toList());
    });
  } else {
    print('Lỗi khi tải dữ liệu: ${response.statusCode}');
    throw Exception('Failed to load entities');
  }
}

Future<void> fetchEntitiesByBranchFromSQLite(String branchId) async {
  final result = await EntityLocalService.getEntitiesByBranch(branchId);

  print('Dữ liệu nhận được từ SQLite: $result');

  setState(() {
    entities.clear();
    entities.addAll(result);
  });
}

 @override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;

  return Scaffold(
    body: Stack(
      children: [
        // Nền
        Container(color: const Color(0xFFE8F9FB)),

        // Hình nền
        Positioned(
          top: 0,
          left: 0,
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
              'images/bg_spa_none.png',
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Nội dung chính
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Tổng sinh nhật
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cột trái
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Box tổng sinh nhật
                      Container(
                        width: 180,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE5A7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Sinh nhật',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text('$birthdayCount'),  // Hiển thị số lượng sinh nhật
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Box chọn tháng sinh nhật
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D2F4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Tháng'),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 40,
                              height: 30,
                              child: TextField(
                                controller: birthdayMonthController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  final month = int.tryParse(value);

                                  setState(() {
                                    if (month != null && month >= 1 && month <= 12) {
                                      // Nếu người dùng nhập vào tháng hợp lệ
                                      birthdayMonth = month;
                                      birthdayCount = countBirthdays(entities, birthdayMonth); // Tính lại số lượng sinh nhật

                                      // Sắp xếp entities theo tháng sinh
                                      entities.sort((a, b) {
                                        final dobA = a['dob']; // Không ép kiểu ở đây
                                        final dobB = b['dob']; // Không ép kiểu ở đây

                                        DateTime? parsedDobA;
                                        DateTime? parsedDobB;

                                        // Nếu dobA và dobB không phải là null và không rỗng
                                        if (dobA != null && dobA.isNotEmpty) {
                                          try {
                                            parsedDobA = DateFormat('dd/MM/yyyy').parse(dobA);
                                          } catch (e) {
                                            print("Lỗi định dạng ngày sinh A: $dobA");
                                            // Xử lý lỗi ở đây nếu cần
                                          }
                                        }

                                        if (dobB != null && dobB.isNotEmpty) {
                                          try {
                                            parsedDobB = DateFormat('dd/MM/yyyy').parse(dobB);
                                          } catch (e) {
                                            print("Lỗi định dạng ngày sinh B: $dobB");
                                            // Xử lý lỗi ở đây nếu cần
                                          }
                                        }
                                        // Nếu dobA hoặc dobB là rỗng (null hoặc chuỗi trống), coi tháng là 0
                                        final monthA = parsedDobA?.month ?? 0;
                                        final monthB = parsedDobB?.month ?? 0;

                                        // Đưa những người có tháng sinh trùng với birthdayMonth lên đầu danh sách
                                        if (monthA == birthdayMonth && monthB != birthdayMonth) {
                                          return -1; // a lên đầu
                                        } else if (monthB == birthdayMonth && monthA != birthdayMonth) {
                                          return 1;  // b lên đầu
                                        } else {
                                          return 0;  // không thay đổi vị trí
                                        }
                                      });
                                    } else {
                                      // Nếu ô tháng trống (hoặc giá trị không hợp lệ), reset lại
                                      birthdayMonth = 0;
                                      birthdayCount = 0; // Không có ai sinh trong tháng này
                                      // Bạn có thể không cần phải sắp xếp lại nếu không có tháng sinh hợp lệ
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Sinh nhật'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Cột phải: 4 box thông tin
                  SizedBox(
                    width: 320, // đảm bảo có đủ chỗ cho 2 box 1 hàng
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildInfoBox('Khách hàng: ', _countEntitiesByType('KH').toString(), const Color(0xFFFFE5A7)),
                        _buildInfoBox('Nhân viên: ', _countEntitiesByType('NV').toString(), const Color(0xFFD9D2F4)),
                        _buildInfoBox('Học viên: ', _countEntitiesByType('HV').toString(), const Color(0xFFD5E8F6)),
                        _buildInfoBox('Giáo viên: ', _countEntitiesByType('GV').toString(), const Color(0xFFC3F7C0)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Chi nhánh',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Tên',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchName = value; // Cập nhật giá trị tìm kiếm theo tên
                          // Lọc entities theo tên
                          filteredEntities = entities.where((entity) {
                            final name = entity['name']?.toLowerCase() ?? '';
                            return name.contains(searchName.toLowerCase()); // So sánh tên tìm kiếm với tên trong entities
                          }).toList();
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      if (isDeleteMode) {
                        // Lấy danh sách đang hiển thị (có thể là filteredEntities hoặc entities)
                        final currentList = searchName.isEmpty ? entities : filteredEntities;

                        // Lấy các entity được chọn dựa theo index trên currentList
                        List<Map<String, dynamic>> toDelete = selectedRows.map((i) => currentList[i]).toList();

                        // Xoá khỏi entities theo giá trị
                        entities.removeWhere((e) => toDelete.contains(e));

                        // Xoá khỏi database với id của các entity
                        for (var entity in toDelete) {
                          int id = entity['id'];  // Lấy id của entity
                          await EntityLocalService.deleteEntity(id);  // Gọi hàm deleteEntity để xoá khỏi database
                        }

                        // Cập nhật lại filteredEntities nếu đang tìm kiếm
                        if (searchName.isNotEmpty) {
                          setState(() {
                            filteredEntities = entities.where((entity) {
                              final name = entity['name']?.toLowerCase() ?? '';
                              return name.contains(searchName.toLowerCase());
                            }).toList();
                          });
                        }

                        // Dọn dẹp lại trạng thái
                        setState(() {
                          selectedRows.clear();
                          isDeleteMode = false;
                          selectAll = false;
                        });
                      } else {
                        setState(() {
                          isDeleteMode = true;
                          selectedRows.clear();
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      // Hành động khi nhấn dấu cộng
                      _showEntityDialog(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Bảng đối tượng
              _buildEntityTable(context),
            ],
          ),
        ),
      ],
    ),
  );
}

int countBirthdays(List<Map<String, dynamic>> entities, int month) {
  int count = 0;
  for (var entity in entities) {
    final dobRaw = entity['dob'];
    if (dobRaw != null && dobRaw.isNotEmpty) {
      try {
        // Sử dụng định dạng 'yyyy-MM-dd' thay vì 'dd/MM/yyyy'
        final dob = DateFormat('yyyy-MM-dd').parse(dobRaw);
        if (dob.month == month) {
          count++;
        }
      } catch (e) {
        print("Lỗi khi phân tích ngày sinh: $dobRaw");
      }
    }
  }
  return count > 0 ? count : 0;  // Trả về 0 nếu không có ai trong tháng đó
}


int _countEntitiesByType(String prefix) {
  return entities.where((entity) => entity['code']?.startsWith(prefix) ?? false).length;
}

void _showEntityDialog(BuildContext context, {Map<String, dynamic>? entity, int? index}) {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> newEntity = Map.from(entity ?? {
    'type': 'Khách hàng',
    'code': '',
    'name': '',
    'phone': '',
    'email': '',
    'gender': 'Nam',
    'cccd': '',
    'hometown': '',
    'dob': '',
    'start_date': '',
    'end_date': '',
    'position': [],
  });
  final codeController = TextEditingController(text: newEntity['code']);
  final positionController = TextEditingController(
  text: (newEntity['position'] != null && newEntity['position'] is List)
      ? (newEntity['position'] as List).join(' + ')
      : '', // Nếu không phải danh sách, trả về chuỗi rỗng
  );
  final dobController = TextEditingController(text: newEntity['dob']);
  final startDateController = TextEditingController(text: newEntity['start_date']);
  final endDateController = TextEditingController(text: newEntity['end_date']);
  final emailController = TextEditingController(text: newEntity['email']);
  final nameController = TextEditingController(text: newEntity['name']);
  final phoneController = TextEditingController(text: newEntity['phone']);
  final cccdController = TextEditingController(text: newEntity['cccd']);
  final hometownController = TextEditingController(text: newEntity['hometown']);


  final Map<String, String> fieldLabels = {
    'type': 'Loại đối tượng',
    'code': 'Mã đối tượng',
    'name': 'Họ tên',
    'phone': 'Số điện thoại',
    'email': 'Email',
    'gender': 'Giới tính',
    'cccd': 'CCCD',
    'hometown': 'Quê quán',
    'dob': 'Ngày sinh',
    'start_date': 'Ngày bắt đầu',
    'end_date': 'Ngày kết thúc',
    'position': 'Chức vụ',
  };

  final fields = fieldLabels.keys.toList();



  showDialog(
  context: context,
  builder: (context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(40),
      child: SizedBox(
        width: 800,
        height: 800,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Text(
                    entity == null ? 'Thêm đối tượng mới' : 'Chỉnh sửa đối tượng',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: List.generate(6, (i) {
                                  final key = fields[i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: key == 'type'
                                        ? _buildDropdownField(
                                            key,
                                            entity,
                                            newEntity,
                                            fieldLabels,
                                            codeController: codeController, 
                                          )
                                        : key == 'code'
                                            ? _buildTextField(
                                                key,
                                                newEntity,
                                                fieldLabels,
                                                controller: codeController,
                                                readOnly: true,
                                              )
                                            : key == 'email'
                                                ? _buildTextField(
                                                    key,
                                                    newEntity,
                                                    fieldLabels,
                                                    controller: emailController,
                                                    onChanged: (value) async {
                                                      print('onChanged called with value: $value');
                                                      final email = value.trim();
                                                      if (email.contains('@')) {
                                                        print('Valid email detected: $email');
                                                        final userData = await _fetchUserByEmail(email);
                                                        if (userData != null) {
                                                          setState(() {
                                                            newEntity['uid'] = userData['uid'] ?? '';
                                                            newEntity['name'] = userData['name'] ?? '';
                                                            newEntity['phone'] = userData['phone'] ?? '';
                                                            newEntity['cccd'] = userData['cccd'] ?? '';
                                                            newEntity['hometown'] = userData['hometown'] ?? '';
                                                            newEntity['dob'] = userData['dob'] ?? '';
                                                            newEntity['start_date'] = userData['created_at'] ?? '';

                                                            final gender = userData['gender'] == 'Male'
                                                                ? 'Nam'
                                                                : userData['gender'] == 'Female'
                                                                    ? 'Nữ'
                                                                    : 'Nam';
                                                            newEntity['gender'] = gender;
                                                            print('Updated newEntity gender: ${newEntity['gender']}');

                                                            nameController.text = userData['name'] ?? '';
                                                            phoneController.text = userData['phone'] ?? '';
                                                            cccdController.text = userData['cccd'] ?? '';
                                                            hometownController.text = userData['hometown'] ?? '';
                                                            dobController.text = userData['dob'] ?? '';
                                                            startDateController.text = userData['created_at'] ?? '';

                                                            print('User data updated: $userData');
                                                          });
                                                        }
                                                      }
                                                    },
                                                  )
                                                : key == 'name'
                                                    ? _buildTextField(
                                                        key,
                                                        newEntity,
                                                        fieldLabels,
                                                        controller: nameController,
                                                    )
                                                    : key == 'phone'
                                                        ? _buildTextField(
                                                            key,
                                                            newEntity,
                                                            fieldLabels,
                                                            controller: phoneController,
                                                        )    
                                                        : key == 'gender'
                                                            ? _buildTextField(
                                                                key,
                                                                newEntity,
                                                                fieldLabels,
                                                            )      
                                                            : SizedBox.shrink(),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                children: List.generate(6, (i) {
                                  final key = fields[i + 6];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: key == 'position'
                                        ? GestureDetector(
                                            onTap: () async {
                                              final selectedPositions = await showDialog<List<String>>(
                                                context: context,
                                                builder: (context) => _MultiSelectDialog(
                                                  title: 'Chọn chức vụ',
                                                  options: ['Khách hàng', 'Học viên', 'Giáo viên', 'Trợ giảng', 'Quản lý', 'Hỗ trợ quản lý', 'Kế toán', 'Giám sát', 'Sỉ', 'Maketing', 'Lễ tân', 'Kho', 'Hành chính nhân sự', 'Kỹ thuật viên', 'Chuyên viên'],
                                                  initialSelected: (newEntity['position'] != null && newEntity['position'] is List<String>)
                                                      ? newEntity['position'] as List<String>
                                                      : [],
                                                ),
                                              );

                                              if (selectedPositions != null) {
                                                setState(() {
                                                  newEntity['position'] = selectedPositions;
                                                  positionController.text = selectedPositions.join(' + ');
                                                });
                                              }
                                            },
                                            child: AbsorbPointer(
                                              child: _buildTextField(
                                                key,
                                                newEntity,
                                                fieldLabels,
                                                controller: positionController,
                                              ),
                                            ),
                                          )
                                        : key == 'dob'
                                            ? _buildTextField(
                                                key,
                                                newEntity,
                                                fieldLabels,
                                                controller: dobController,
                                                readOnly: true,
                                            )
                                        : key == 'start_date'
                                            ? _buildTextField(
                                                key,
                                                newEntity,
                                                fieldLabels,
                                                controller: startDateController,
                                                readOnly: true,
                                            )
                                        : key == 'end_date'
                                            ? _buildTextField(
                                                key,
                                                newEntity,
                                                fieldLabels,
                                                controller: endDateController,
                                                readOnly: true,
                                            )    
                                        : key == 'cccd'
                                            ? _buildTextField(
                                                key,
                                                newEntity,
                                                fieldLabels,
                                                controller: cccdController,
                                            )
                                        : key == 'hometown'
                                            ? _buildTextField(
                                                key,
                                                newEntity,
                                                fieldLabels,
                                                controller: hometownController,
                                            )
                                        : _buildTextField(key, newEntity, fieldLabels),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.cancel),
                        label: const Text('Hủy'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Lưu'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (entity == null) {
                              // Trường hợp thêm mới
                              try {
                                final result = await EntityLocalService.addEntity({
                                  'uid': newEntity['uid'],
                                  'branch_id': widget.branch['branch_id'],
                                  'type': newEntity['type'],
                                  'code': newEntity['code'],
                                  'phone': newEntity['phone'],
                                  'email': newEntity['email'],
                                  'name': newEntity['name'],
                                  'gender': newEntity['gender'],
                                  'cccd': newEntity['cccd'],
                                  'hometown': newEntity['hometown'],
                                  'dob': formatDate(newEntity['dob']),
                                  'start_date': formatDate(newEntity['start_date']),
                                  'end_date': formatDate(newEntity['end_date']),
                                  'position': newEntity['position'], // sẽ được encode trong service
                                });
                                print('Entity added successfully: $result');
                                setState(() {
                                  entities.add(Map.from(newEntity));
                                });
                                fetchEntitiesByBranchFromSQLite(widget.branch['branch_id']);
                                Navigator.pop(context);
                              } catch (e) {
                                print('Error adding entity: $e');
                                // Hiển thị thông báo lỗi nếu cần
                              }
                            } else {
                              // Trường hợp cập nhật
                              try {
                        // Gọi hàm updateEntity để cập nhật dữ liệu vào SQLite
                                await EntityLocalService.updateEntity(
                                  entity['id'], // Truyền vào ID của entity để cập nhật
                                  {
                                    'branch_id': widget.branch['branch_id'],
                                    'type': newEntity['type'],
                                    'code': newEntity['code'],
                                    'name': newEntity['name'],
                                    'phone': newEntity['phone'],
                                    'email': newEntity['email'],
                                    'gender': newEntity['gender'],
                                    'cccd': newEntity['cccd'],
                                    'hometown': newEntity['hometown'],
                                    'dob': formatDate(newEntity['dob']),
                                    'start_date': formatDate(newEntity['start_date']),
                                    'end_date': formatDate(newEntity['end_date']),
                                    'position': newEntity['position'],  // Chắc chắn 'position' là List<String>
                                  },
                                );

                                print('Entity updated successfully!');
                                
                                // Cập nhật lại danh sách entities trong UI
                                setState(() {
                                  entities[index!] = Map.from(newEntity); // Cập nhật entity tại index tương ứng
                                });
                                fetchEntitiesByBranchFromSQLite(widget.branch['branch_id']);

                                Navigator.pop(context);
                              } catch (e) {
                                print('Error updating entity: $e');
                                // Hiển thị thông báo lỗi nếu cần
                              }

                            }
                          }
                        },
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  },
);

}

String? formatDate(dynamic date) {
  if (date == null) return null;

  if (date is DateTime) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  if (date is String) {
    try {
      // Nếu là dd/MM/yyyy
      if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(date)) {
        final parts = date.split('/');
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final dt = DateTime(year, month, day);
        return "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
      }

      // Mặc định: ISO 8601
      final parsed = DateTime.parse(date);
      return "${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";
    } catch (e) {
      print('Không parse được date: $date');
      return null;
    }
  }

  return null;
}

Future<String?> fetchEntityCodeFromSQLite({
  required String type,
  String? branchId,
}) async {
  try {
    final code = await EntityLocalService.generateEntityCode(type, branchId: branchId);
    print('Mã đối tượng (local): $code');
    return code;
  } catch (e) {
    print('Lỗi khi tạo mã local: $e');
    return null;
  }
}


Future<String?> fetchAndPrintEntityCode({
  required String type,
  String? branchId,
}) async {
  final uri = Uri.parse('http://14.225.217.157:3002/entities/new-code').replace(
    queryParameters: {
      'type': type,
      if (branchId != null) 'branchId': branchId,
    },
  );

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final code = data['code'];
      print('Mã đối tượng: $code');
      return code; // Trả về mã đối tượng
    } else {
      print('Lỗi khi lấy mã: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (e) {
    print('Lỗi kết nối: $e');
    return null;
  }
}

Future<Map<String, dynamic>> addEntity({
  required String uid,
  required String branchId,
  required String type,
  required String code,
  String? phone,
  String? email,
  String? name,
  String? gender,
  String? cccd,
  String? hometown,
  String? dob,
  String? startDate,
  String? endDate,
  List<String>? position,
}) async {
  final url = Uri.parse('http://14.225.217.157:3002/entities'); // thay bằng URL thật
  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    'uid': uid,
    'branch_id': branchId,
    'type': type,
    'code': code,
    'phone': phone,
    'email': email,
    'gender': gender,
    'cccd': cccd,
    'hometown': hometown,
    'dob': dob,
    'start_date': startDate,
    'end_date': endDate,
    'position': position != null ? jsonEncode(position) : null,
  });

  print('Request body: $body');

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Lỗi khi thêm entity: ${response.body}');
  }
}

Future<void> updateEntity({
  required int id,
  required String branchId,
  required String type,
  required String code,
  required String name,
  String? phone,
  String? email,
  String? gender,
  String? cccd,
  String? hometown,
  String? dob,
  String? startDate,
  String? endDate,
  List<String>? position,
}) async {
  final url = Uri.parse('http://14.225.217.157:3002/entities/$id'); // Sử dụng ID thay vì UID
  final headers = {'Content-Type': 'application/json'};

  final body = json.encode({
    'branch_id': branchId,
    'type': type,
    'code': code,
    'name': name,
    'phone': phone,
    'email': email,
    'gender': gender,
    'cccd': cccd,
    'hometown': hometown,
    'dob': dob,
    'start_date': startDate,
    'end_date': endDate,
    'position': position != null ? json.encode(position) : null,
  });

  final response = await http.put(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Entity updated successfully!');
  } else {
    print('Failed to update entity. Status code: ${response.statusCode}');
  }
}


Widget _buildTextField(
  String key,
  Map<String, dynamic> entity,
  Map<String, String> labels, {
  TextEditingController? controller,
  bool readOnly = false,
  String? hintText,
  bool enabled = true,
  void Function(String)? onChanged,
}) {
  final iconMap = {
    'code': Icons.tag,
    'name': Icons.person,
    'phone': Icons.phone,
    'email': Icons.email,
    'gender': Icons.wc,
    'cccd': Icons.credit_card,
    'hometown': Icons.home,
    'dob': Icons.calendar_today,
    'start_date': Icons.calendar_view_day,
    'end_date': Icons.event,
    'position': Icons.work,
  };

  // Xử lý trường giới tính
  if (key == 'gender') {
    return DropdownButtonFormField<String>(
      key: ValueKey(entity[key]), // Đảm bảo giá trị entity được truyền vào đúng
      value: entity[key] ?? 'Nam', // Giá trị mặc định là 'Nam' nếu entity[key] là null
      decoration: InputDecoration(
        labelText: labels[key],
        prefixIcon: Icon(iconMap[key], size: 20),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: ['Nam', 'Nữ'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: enabled
          ? (value) {
              if (value != null) {
                setState(() {
                  // Cập nhật lại giá trị trong entity
                  entity[key] = value;
                  print('Updated gender: $value');
                });
              }
            }
          : null,
      validator: (value) => (value ?? '').isEmpty ? 'Không được để trống' : null,
    );
  }

  // Xử lý các trường ngày tháng
  if (key == 'dob' || key == 'start_date' || key == 'end_date') {
    return TextFormField(
      controller: controller,
      readOnly: true, // Không cho phép nhập trực tiếp
      decoration: InputDecoration(
        labelText: labels[key],
        hintText: hintText ?? 'Chọn ngày...',
        prefixIcon: GestureDetector(
          onTap: () async {
            DateTime initialDate = DateTime.now();
            if (controller?.text.isNotEmpty == true) {
              try {
                initialDate = DateFormat('dd/MM/yyyy').parse(controller!.text);
              } catch (e) {}
            }

            final selectedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            if (selectedDate != null) {
              final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
              controller?.text = formattedDate;
              entity[key] = formattedDate;  // Cập nhật entity
              setState(() {}); // Làm mới UI sau khi chọn ngày
            }
          },
          child: Icon(iconMap[key], size: 20),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(fontSize: 14),
      //validator: (value) => (value ?? '').isEmpty ? 'Không được để trống' : null,
    );
  }

  // Mặc định cho các trường khác
  return TextFormField(
    controller: controller,
    initialValue: controller == null ? entity[key]?.toString() : null,
    readOnly: readOnly,
    enabled: enabled,
    decoration: InputDecoration(
      labelText: labels[key],
      hintText: hintText ?? 'Nhập ${labels[key]?.toLowerCase()}...',
      prefixIcon: Icon(iconMap[key], size: 20),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    style: const TextStyle(fontSize: 14),
    onChanged: (value) {
      entity[key] = value;  // Cập nhật giá trị trong entity
      setState(() {});  // Làm mới UI
      if (onChanged != null) {
        onChanged(value);  // Gọi logic từ bên ngoài nếu có
      }
    },
    validator: (value) {
      if ((key == 'name' || key == 'position') && (value ?? '').trim().isEmpty) {
        return 'Không được để trống';
      }
      return null;
    },
  );
}


Future<Map<String, dynamic>?> _fetchUserByEmail(String email) async {
  try {
    final encodedEmail = Uri.encodeComponent(email);
    final response = await http.get(Uri.parse('http://14.225.217.157:3002/users/email/$encodedEmail'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Response: $data'); // In ra dữ liệu trả về từ API
      return data as Map<String, dynamic>; // Trả về toàn bộ dữ liệu
    } else {
      print('API Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching user by email: $e');
    return null;
  }
}


Widget _buildDropdownField(
  String key,
  Map<String, dynamic>? eentity,
  Map<String, dynamic> entity, 
  Map<String, String> labels, {
  void Function(String)? onChanged,
  required TextEditingController codeController,  // Thêm codeController vào tham số
}) {
  final List<String> options = [
    'Khách hàng',
    'Học viên',
    'Giáo viên',
    'Nhân viên',
  ];

  // Mảng ánh xạ từ tiếng Việt sang mã đối tượng
  final Map<String, String> typeMap = {
    'Khách hàng': 'customer',
    'Học viên': 'student',
    'Giáo viên': 'teacher',
    'Nhân viên': 'staff',
  };

  // Sử dụng branch_id từ biến đã có sẵn
  String? branchId = widget.branch['branch_id'];

  // Gọi fetchAndPrintEntityCode khi widget được dựng (nếu có giá trị ban đầu)
  if (entity[key] != null&&eentity == null) {
    String? type = typeMap[entity[key]];
    if (type != null) {
      fetchEntityCodeFromSQLite(
        type: type,
        branchId: branchId,
      ).then((newCode) {
        if (newCode != null) {
          entity['code'] = newCode; 
          codeController.text = newCode;  // Gán giá trị mới vào controller
        } else {
          print("Lỗi: Không nhận được mã từ fetchAndPrintEntityCode");
        }
      });
    }
  }

  return DropdownButtonFormField<String>(
    value: entity[key],  // Giá trị hiện tại của entity
    decoration: InputDecoration(
      labelText: labels[key],  // Tên label từ labels
      prefixIcon: const Icon(Icons.category, size: 20),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    style: const TextStyle(fontSize: 14, color: Colors.black),
    dropdownColor: Colors.white,
    items: options.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value, style: const TextStyle(color: Colors.black)),
      );
    }).toList(),
    onChanged: (value) async {
      if (value != null) {
        // Cập nhật giá trị entity theo key
        entity[key] = value;

        // Chuyển từ tiếng Việt sang mã đối tượng hợp lệ
        String? type = typeMap[value];

        if (type != null) {
          // Gọi callback onChanged nếu có
          onChanged?.call(value);

          // Gọi fetchAndPrintEntityCode và lấy giá trị trả về
          final newCode = await fetchEntityCodeFromSQLite(
            type: type,  // Gọi mã đối tượng hợp lệ
            branchId: branchId,
          );

          // Gán mã mới vào codeController, nếu newCode là null thì gán giá trị mặc định
          entity['code'] = newCode; 
          codeController.text = newCode ?? ''; // Gán giá trị mặc định nếu null
        } else {
          print("Lỗi: Không tìm thấy mã đối tượng hợp lệ cho '$value'");
        }
      }
    },
    validator: (value) => (value ?? '').isEmpty ? 'Không được để trống' : null,
  );
}



Widget _buildInfoBox(String label, String value, Color color) {
  return Container(
    width: 140,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.black12),
    ),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        children: [
          TextSpan(text: label),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}



Widget _buildEntityTable(BuildContext context) {
  final currentList = searchName.isEmpty ? entities : filteredEntities;

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(
            color: Colors.black26,
            width: 1,
            borderRadius: BorderRadius.circular(4),
          ),
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFCCE5FF),
              ),
              children: [
                if (isDeleteMode)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Checkbox(
                      value: selectAll,
                      onChanged: (value) {
                        setState(() {
                          selectAll = value ?? false;
                          if (selectAll) {
                            selectedRows = Set.from(currentList.asMap().keys);
                          } else {
                            selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                _buildTableHeaderCell('Mã'),
                _buildTableHeaderCell('Tên'),
                _buildTableHeaderCell('SĐT'),
                _buildTableHeaderCell('Email'),
                _buildTableHeaderCell('Giới tính'),
                _buildTableHeaderCell('CCCD'),
                _buildTableHeaderCell('Quê quán'),
                _buildTableHeaderCell('Ngày sinh'),
                _buildTableHeaderCell('Bắt đầu'),
                _buildTableHeaderCell('Kết thúc'),
                _buildTableHeaderCell('Chức vụ'),
              ],
            ),
          ],
        ),
        ...currentList.asMap().entries.map((entry) {
          final index = entry.key;
          final entity = entry.value;

          return InkWell(
            onTap: () {
              final realIndex = entities.indexOf(entity); // Tìm index thực
              _showEntityDialog(context, entity: entity, index: realIndex);
            },
            child: Table(
              border: TableBorder.all(
                color: Colors.black26,
                width: 0.5,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: selectedRows.contains(index)
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.white,
                  ),
                  children: [
                    if (isDeleteMode)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Checkbox(
                          value: selectedRows.contains(index),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                selectedRows.add(index);
                              } else {
                                selectedRows.remove(index);
                              }
                              selectAll = selectedRows.length == currentList.length;
                            });
                          },
                        ),
                      ),
                    _buildTableCell(entity['code'] ?? ''),
                    _buildTableCell(entity['name'] ?? ''),
                    _buildTableCell(entity['phone'] ?? ''),
                    _buildTableCell(entity['email'] ?? ''),
                    _buildTableCell(entity['gender'] ?? ''),
                    _buildTableCell(entity['cccd'] ?? ''),
                    _buildTableCell(entity['hometown'] ?? ''),
                    _buildTableCell(entity['dob'] ?? ''),
                    _buildTableCell(entity['start_date'] ?? ''),
                    _buildTableCell(entity['end_date'] ?? ''),
                    _buildTableCell((entity['position'] as List<String>).join(' + ') ?? ''),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}




Widget _buildTableHeaderCell(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildTableCell(String content) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(content),
  );
}

}

class _MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> initialSelected;

  const _MultiSelectDialog({
    required this.title,
    required this.options,
    required this.initialSelected,
  });

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 375, // Tăng chiều rộng (lớn hơn 250 một nửa)
        height: 338, // Tăng chiều cao (lớn hơn 300 một nửa)
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Chia thành 3 cột
            crossAxisSpacing: 8, // Khoảng cách giữa các cột
            mainAxisSpacing: 8, // Khoảng cách giữa các hàng
            childAspectRatio: 2, // Tỷ lệ chiều rộng / chiều cao
          ),
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            final option = widget.options[index];
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selected.remove(option);
                  } else {
                    selected.add(option);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 12, // Giảm kích thước chữ để vừa ô
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selected),
          child: const Text('Xong'),
        ),
      ],
    );
  }
}


