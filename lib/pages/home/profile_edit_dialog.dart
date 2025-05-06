import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ProfileEditDialog extends StatefulWidget {
  final String uid; // UID của người dùng cần cập nhật
  final Map<String, dynamic> userData; // Chuyển sang Map<String, dynamic>

  const ProfileEditDialog({required this.uid, required this.userData, Key? key}) : super(key: key);

  @override
  _ProfileEditDialogState createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;
  late TextEditingController _cccdController;
  late TextEditingController _hometownController;
  late TextEditingController _dobController;
  late TextEditingController _createdAtController; // Controller cho ngày bắt đầu

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với giá trị ban đầu từ userData
    _emailController = TextEditingController(text: widget.userData['email'] ?? '');
    _nameController = TextEditingController(text: widget.userData['name'] ?? '');
    _phoneController = TextEditingController(text: widget.userData['phone'] ?? '');
    _genderController = TextEditingController(text: widget.userData['gender'] ?? '');
    _cccdController = TextEditingController(text: widget.userData['cccd'] ?? '');
    _hometownController = TextEditingController(text: widget.userData['hometown'] ?? '');
    _dobController = TextEditingController(text: widget.userData['dob'] ?? '');
    _createdAtController = TextEditingController(text: widget.userData['created_at'] ?? ''); // Gán giá trị ngày bắt đầu
    _nameController.addListener(() {
      setState(() {}); // Mỗi khi _nameController thay đổi, gọi setState để cập nhật lại giao diện
    });
  }

    @override
  void dispose() {
    _nameController.dispose(); // Đảm bảo giải phóng tài nguyên khi widget bị hủy
    super.dispose();
  }


  // Hàm cập nhật thông tin người dùng
  Future<void> _updateUserInfo() async {
  if (!_isLoading) {
    setState(() {
      _isLoading = true;
    });
  }

  final url = 'http://14.225.217.157:3002/users/${widget.uid}'; // URL của API

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _emailController.text,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'gender': _genderController.text,
        'cccd': _cccdController.text,
        'hometown': _hometownController.text,
        'dob': formattedDate(_dobController.text),
        'created_at': _createdAtController.text, // Cập nhật ngày bắt đầu
      }),
    );

    if (response.statusCode == 200) {
      // Cập nhật thành công
      final updatedUserData = {
        'email': _emailController.text,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'gender': _genderController.text,
        'cccd': _cccdController.text,
        'hometown': _hometownController.text,
        'dob': formattedDate(_dobController.text), 
        'created_at': _createdAtController.text,
      };
      
      if (mounted) {
        Navigator.pop(context, updatedUserData); // Trả về dữ liệu người dùng sau khi cập nhật
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thông tin người dùng đã được cập nhật!')),
        );
      }
    } else {
      // Cập nhật thất bại
      print('Cập nhật thất bại: ${response.statusCode}');
      print('Chi tiết lỗi: ${response.body}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thất bại!')),
        );
      }
    }
  } catch (e) {
    // Bắt lỗi và hiển thị thông báo
    print('Lỗi khi gọi API: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã có lỗi xảy ra, vui lòng thử lại!')),
      );
    }
  } finally {
    // Đảm bảo luôn cập nhật lại trạng thái loading
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

String formattedDate(String dateString) {
  try {
    // Chuyển đổi ngày từ chuỗi thành DateTime
    DateTime date = DateTime.parse(dateString);
    // Định dạng lại ngày theo định dạng "yyyy-MM-dd"
    return DateFormat('yyyy-MM-dd').format(date);
  } catch (e) {
    print('Lỗi khi định dạng ngày: $e');
    return dateString; // Trả về chuỗi gốc nếu không thể định dạng
  }
}

   @override
Widget build(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    title: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue,
          child: Text(
            _nameController.text.isNotEmpty
                ? _nameController.text.trim()[0].toUpperCase()
                : '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.edit, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Cập nhật thông tin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ],
    ),
    content: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dòng đầu tiên với 2 ô
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_emailController, 'Email', readOnly: true, prefixIcon: const Icon(Icons.email_outlined)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(_nameController, 'Họ và tên', prefixIcon: const Icon(Icons.person_outline)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Dòng thứ hai
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_phoneController, 'Số điện thoại', prefixIcon: const Icon(Icons.phone_outlined)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGenderField(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Dòng thứ ba
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_cccdController, 'CCCD', prefixIcon: const Icon(Icons.card_membership_outlined)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(_hometownController, 'Quê quán', prefixIcon: const Icon(Icons.location_on_outlined)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Dòng thứ tư
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(_dobController, 'Ngày sinh (YYYY-MM-DD)', false),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        _createdAtController,
                        'Ngày bắt đầu',
                        readOnly: true,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Hủy', style: TextStyle(fontSize: 18)),
      ),
      const SizedBox(width: 16),
      ElevatedButton(
        onPressed: _updateUserInfo,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 2,
        ),
        child: const Text('Cập nhật', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    ],
  );
}




Widget _buildGenderField() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: DropdownButtonFormField<String>(
      value: _genderController.text.isEmpty ? 'Male' : _genderController.text, // Nếu không có giá trị, mặc định là Nam
      onChanged: (String? newValue) {
        setState(() {
          _genderController.text = newValue!; // Cập nhật giá trị vào controller
        });
      },
      items: const [
        DropdownMenuItem(value: 'Male', child: Text('Nam')),
        DropdownMenuItem(value: 'Female', child: Text('Nữ')),
      ],
      decoration: InputDecoration(
        labelText: 'Giới tính',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}



// Hàm hỗ trợ tạo TextField có style
Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (picked != null && picked != DateTime.now()) {
    setState(() {
      controller.text = "${picked.toLocal()}".split(' ')[0]; // Format date as YYYY-MM-DD
    });
  }
}

Widget _buildDateField(TextEditingController controller, String label, bool readOnly) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context, controller),
        ),
      ),
      readOnly: readOnly,
    ),
  );
}


// Updated TextField to show DatePicker button when applicable:
Widget _buildTextField(TextEditingController controller, String label, {Widget? prefixIcon, bool readOnly = false, bool isDate = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: prefixIcon, // Thêm prefixIcon vào đây
        suffixIcon: isDate
            ? IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context, controller),
              )
            : null,
      ),
      readOnly: readOnly,
    ),
  );
}


}

