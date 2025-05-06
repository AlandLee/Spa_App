import 'package:flutter/material.dart';

class ImportFormDialog extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  ImportFormDialog({
  super.key,
  required this.branch,
  required this.userData,
});


  @override
  State<ImportFormDialog> createState() => _ImportFormDialogState();
}

class _ImportFormDialogState extends State<ImportFormDialog> {
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _completionDateController = TextEditingController();
  final TextEditingController _poNumberController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();

  @override
  void dispose() {
    _orderDateController.dispose();
    _completionDateController.dispose();
    _poNumberController.dispose();
    _branchController.dispose();
    _statusController.dispose();
    _totalAmountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Center(
    child: SizedBox(
      width: screenWidth * 2 / 3, // Chiều ngang chỉ chiếm 2/3 màn hình
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              color: const Color(0xFFE8F9FB),
            ),
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
                  // Hàng 1
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_orderDateController, 'Ngày đặt hàng')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_customerController, 'Ngày nhận')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_serviceController, 'Số PO')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_serviceController, 'Số phiếu')),
                      const SizedBox(width: 8),
                      _buildIconButton(Icons.search, () {}),
                      _buildIconButton(Icons.save, () {}),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Hàng 2
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_branchController, 'Chi nhánh')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_statusController, 'Mã')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_statusController, 'Tên')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_branchController, 'CK')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_statusController, 'VAT')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_noteController, 'Tổng tiền')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_statusController, 'Thanh toán')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_noteController, 'Còn lại')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_noteController, 'Ghi chú')),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Bảng
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildImportTable(context),
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
                    const Center(
                      child: Text(
                        'Thêm phiếu nhập',
                        style: TextStyle(
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

  Widget _buildImportTable(BuildContext context) {
  final List<Map<String, String>> orders = [];

  // Tạo danh sách có ít nhất 5 phần tử
  final displayOrders = List.generate(
    5,
    (index) => index < orders.length
        ? orders[index]
        : {
            'code': '',
            'name': '',
            'unit': '',
            'type': '',
            'quantity': '',
            'unit_price': '',
            'ck': '',
            'total_price': '',
          },
  );

  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2),
            5: FlexColumnWidth(2),
            6: FlexColumnWidth(2),
            7: FlexColumnWidth(2),
          },
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
                _buildTableHeaderCell('Mã hàng'),
                _buildTableHeaderCell('Tên hàng'),
                _buildTableHeaderCell('ĐVT'),
                _buildTableHeaderCell('Loại'),
                _buildTableHeaderCell('Số lượng'),
                _buildTableHeaderCell('Đơn giá'),
                _buildTableHeaderCell('CK'),
                _buildTableHeaderCell('Thành tiền'),
              ],
            ),
          ],
        ),
        ...displayOrders.map((order) {
          return GestureDetector(
            onTap: () {
              // showOrderDialog(context);
            },
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
                6: FlexColumnWidth(2),
                7: FlexColumnWidth(2),
              },
              border: TableBorder.all(
  color: Colors.black26,
  width: 0.5,
),

              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  children: [
                    _buildTableCell(order['code']!),
                    _buildTableCell(order['name']!),
                    _buildTableCell(order['unit']!),
                    _buildTableCell(order['type']!),
                    _buildTableCell(order['quantity']!),
                    _buildTableCell(order['unit_price']!),
                    _buildTableCell(order['ck']!),
                    _buildTableCell(order['total_price']!),
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



Widget _buildTableHeaderCell(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
  );
}


Widget _buildTableCell(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
  );
}

}
