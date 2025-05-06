import 'package:flutter/material.dart';
import 'dart:convert';

class AppointmentFormDialog extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;
  final Map<String, String>? schedule; // 👈 Thêm dòng này

  AppointmentFormDialog({
    super.key,
    required this.branch,
    required this.userData,
    this.schedule, // 👈 Và dòng này nữa
  });


  @override
  State<AppointmentFormDialog> createState() => _AppointmentFormDialogState();
}

class _AppointmentFormDialogState extends State<AppointmentFormDialog> {
  final TextEditingController _orderDateController = TextEditingController();     // Ngày hẹn
  final TextEditingController _hourController = TextEditingController();          // Giờ
  final TextEditingController _scheduleIdController = TextEditingController();    // Số (mã phiếu)

  final TextEditingController _branchController = TextEditingController();        // Chi nhánh
  final TextEditingController _statusController = TextEditingController();        // Trạng thái

  final TextEditingController _customerIdController = TextEditingController();    // Mã KH
  final TextEditingController _customerNameController = TextEditingController();  // Tên KH
  final TextEditingController _phoneController = TextEditingController();         // SĐT
  final TextEditingController _noteController = TextEditingController();          // Ghi chú
  List<String> productCodes = [];
  late Map<String, String> _localSchedule;
  final List<Map<String, String>> services = [
    {'id': '1', 'name': 'Massage Thư Giãn Toàn Thân'},
    {'id': '2', 'name': 'Chăm Sóc Da Mặt Cơ Bản'},
    {'id': '3', 'name': 'Mặt Nạ Dưỡng Ẩm'},
    {'id': '4', 'name': 'Chăm Sóc Mắt Chuyên Sâu'},
    {'id': '5', 'name': 'Massage Vai - Cổ - Lưng'},
    {'id': '6', 'name': 'Xông Hơi Thảo Dược'},
    {'id': '7', 'name': 'Tẩy Tế Bào Chết Toàn Thân'},
    {'id': '8', 'name': 'Chăm Sóc Da Mặt Chuyên Sâu'},
    {'id': '9', 'name': 'Massage Thái'},
    {'id': '10', 'name': 'Chăm Sóc Móng Tay - Móng Chân'},
    {'id': '11', 'name': 'Chữa Mụn Bằng Công Nghệ Laser'},
    {'id': '12', 'name': 'Chăm Sóc Da Mặt Với Vitamin C'},
    {'id': '13', 'name': 'Massage Chân'},
    {'id': '14', 'name': 'Trị Liệu Nám Da'},
    {'id': '15', 'name': 'Làm Sạch Da Bằng Công Nghệ Oxy Jet'},
    {'id': '16', 'name': 'Chăm Sóc Da Bằng Tế Bào Gốc'},
    {'id': '17', 'name': 'Điều Trị Da Nhạy Cảm'},
    {'id': '18', 'name': 'Cạo Lông Mặt'},
    {'id': '19', 'name': 'Tẩy Lông Vùng Bikini'},
    {'id': '20', 'name': 'Chăm Sóc Da Chống Lão Hóa'},
    {'id': '21', 'name': 'Trị Liệu Mụn Cơ Bản'},
    {'id': '22', 'name': 'Sử Dụng Dầu Massage Aromatherapy'},
    {'id': '23', 'name': 'Làm Mờ Vết Thâm Bằng Laser'},
    {'id': '24', 'name': 'Trị Liệu Hút Mỡ'},
    {'id': '25', 'name': 'Chăm Sóc Da Mặt Bằng Masage Lạnh'},
    {'id': '26', 'name': 'Chăm Sóc Da Mặt Bằng Máy IPL'},
    {'id': '27', 'name': 'Dịch Vụ Tẩy Trang Chuyên Sâu'},
    {'id': '28', 'name': 'Điều Trị Da Đặc Biệt Cho Phụ Nữ Mang Thai'},
    {'id': '29', 'name': 'Trị Liệu Tăng Cường Collagen'},
    {'id': '30', 'name': 'Dịch Vụ Phục Hồi Sau Phẫu Thuật'},
    {'id': '31', 'name': 'Chăm Sóc Mắt Thư Giãn'},
    {'id': '32', 'name': 'Dịch Vụ Giảm Stress Và Lo Âu'},
    {'id': '33', 'name': 'Trị Liệu Thoái Hóa Cột Sống'},
    {'id': '34', 'name': 'Chăm Sóc Da Cho Nam'},
    {'id': '35', 'name': 'Làm Móng Chân Cơ Bản'},
    {'id': '36', 'name': 'Chăm Sóc Móng Tay Đặc Biệt'},
    {'id': '37', 'name': 'Sử Dụng Kem Dưỡng Ẩm Da'},
    {'id': '38', 'name': 'Sử Dụng Serum Chống Lão Hóa'},
    {'id': '39', 'name': 'Tẩy Da Chết Với Muối Biển'},
    {'id': '40', 'name': 'Dịch Vụ Tắm Trắng Toàn Thân'},
  ];

  List<bool> selected = List<bool>.filled(40, false);

  @override
  void initState() {
    super.initState();
    _localSchedule = Map<String, String>.from(widget.schedule ?? {});
    final s = widget.schedule;
    if (s != null) {
      _orderDateController.text = s['date'] ?? ''; // Ngày hẹn
      _hourController.text = s['hour'] ?? ''; // Giờ
      _scheduleIdController.text = s['id'] ?? ''; // Số phiếu hẹn

      _branchController.text = widget.branch['name'] ?? ''; // Chi nhánh
      _statusController.text = s['status'] ?? ''; // Trạng thái

      _customerIdController.text = s['entity_id'] ?? ''; // Mã KH
      _customerNameController.text = s['name'] ?? ''; // Tên KH
      _phoneController.text = s['phone'] ?? ''; // SĐT
      _noteController.text = s['note'] ?? ''; // Ghi chú
      productCodes = getProductCodes();
    }
    for (int i = 0; i < services.length; i++) {
      if (productCodes.contains(services[i]['id'])) {
        selected[i] = true;
      }
    }
  }

  Map<String, String> buildScheduleFromForm({
  required String branchName,
  required List<Map<String, String>> products,
}) {
  return {
    'id': _scheduleIdController.text,
    'entity_id': _customerIdController.text,
    'name': _customerNameController.text,
    'phone': _phoneController.text,
    'rank': '', // Nếu bạn có rank, thêm controller hoặc gán cứng
    'date': _orderDateController.text,
    'hour': _hourController.text,
    'note': _noteController.text,
    'service': '', // Nếu có field dịch vụ thì thêm controller
    'status': _statusController.text,
    'productList': products.map((e) => {
      'productName': e['productName'] ?? '',
      'code': e['code'] ?? '',
    }).toList().toString(),
  };
}

List<Map<String, String>> getProductListFromSelected() {
  final selectedServices = <Map<String, String>>[];
  for (int i = 0; i < selected.length; i++) {
    if (selected[i]) {
      selectedServices.add({
        'productName': services[i]['name'] ?? '',
        'code': services[i]['id'] ?? '',
      });
    }
  }
  return selectedServices;
}

  @override
  void dispose() {
    _orderDateController.dispose();
    _hourController.dispose();
    _scheduleIdController.dispose();

    _branchController.dispose();
    _statusController.dispose();

    _customerIdController.dispose();
    _customerNameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  List<String> getProductCodes() {
  if (widget.schedule != null) {
    final schedule = widget.schedule!;
    if (schedule['productList'] != null) {
      // Giải mã dữ liệu productList thành List<Map<String, dynamic>>
      final List<Map<String, dynamic>> productList = List<Map<String, dynamic>>.from(json.decode(schedule['productList']!));

      // Trích xuất danh sách các mã dịch vụ (code)
      return productList.map((product) => product['code'] as String).toList();
    }
  }
  return [];
}


  @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Center(
    child: SizedBox(
      width: screenWidth * 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(color: const Color(0xFFE8F9FB)),
            Positioned.fill(
              child: Image.asset(
                'images/bg_spa_none.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Hàng 1 ===
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_orderDateController, 'Ngày hẹn')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_hourController, 'Giờ')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_scheduleIdController, 'Số')),
                      const SizedBox(width: 8),
                      _buildIconButton(Icons.save, () {
  final updatedSchedule = buildScheduleFromForm(
    branchName: widget.branch['name'] ?? '',
    products: getProductListFromSelected(),
  );

  setState(() {
    _localSchedule = updatedSchedule;
  });

  print("Updated Schedule: $_localSchedule");
})



                    ],
                  ),
                  const SizedBox(height: 8),

                  // === Hàng 2 (chỉ hiển thị nếu có schedule) ===
                  if (widget.schedule != null)
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_branchController, 'Chi nhánh')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField(_statusController, 'Trạng thái')),
                      ],
                    ),

                  const SizedBox(height: 12),

                  // === Hàng 3: Mã KH - Tên - SĐT ===
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_customerIdController, 'Mã khách hàng')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_customerNameController, 'Tên')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_phoneController, 'Số điện thoại')),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // === Ghi chú ===
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_noteController, 'Ghi chú')),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // === Danh sách dịch vụ/sản phẩm ===
                  Expanded(
                    child: SingleChildScrollView(
                      child: buildServiceSelection(),
                    ),
                  ),
                ],
              ),
            ),

            // === TIÊU ĐỀ VÀ NÚT ĐÓNG ===
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 48,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.schedule != null ? 'Cập nhật phiếu hẹn' : 'Thêm phiếu hẹn',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(); // Đóng dialog
                        },
                        child: const Icon(Icons.close, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



  // Các controller, hàm _buildTextField, _buildIconButton, _buildScheduleTable bạn tự thêm vào file này nhé.
  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 1.5), // Tăng độ dày viền
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 1.5, color: Colors.grey), // Viền khi không focus
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: Colors.blue), // Viền khi focus
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        tooltip: icon == Icons.search
            ? 'Tìm kiếm'
            : 'Lưu',
      ),
    );
  }


 Widget buildServiceSelection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Chọn dịch vụ:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(4, (colIndex) {
          final columns = services.sublist(colIndex * 10, (colIndex + 1) * 10);

          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(columns.length, (itemIndex) {
                final globalIndex = colIndex * 10 + itemIndex;

                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    columns[itemIndex]['name']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                  value: selected[globalIndex],
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      selected[globalIndex] = value!;
                    });
                  },
                );
              }),
            ),
          );
        }),
      ),
    ],
  );
}

}
