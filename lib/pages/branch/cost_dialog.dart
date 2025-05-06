import 'package:flutter/material.dart';

class CostFormDialog extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  CostFormDialog({
  super.key,
  required this.branch,
  required this.userData,
});


  @override
  State<CostFormDialog> createState() => _CostFormDialogState();
}

class _CostFormDialogState extends State<CostFormDialog> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _costPercentController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _unitPriceController.dispose();
    _costController.dispose();
    _costPercentController.dispose();
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
                      Expanded(child: _buildTextField(_codeController, 'Mã sản phẩm')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_nameController, 'Tên')),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Hàng 2
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_unitPriceController, 'Đơn giá')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_costController, 'Cost')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_costPercentController, '%Cost')),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Bảng
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildCostTable(context),
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
                        'Thêm Cost',
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

  Widget _buildCostTable(BuildContext context) {
  final List<Map<String, String>> costs = [
    {
      'materialCode': 'VT001',
      'name': 'Nguyên liệu A',
      'unit': 'Kg',
      'unitPrice': '100,000',
      'quantity': '2',
    },
    {
      'materialCode': 'VT002',
      'name': 'Nguyên liệu B',
      'unit': 'Lít',
      'unitPrice': '150,000',
      'quantity': '1.5',
    },
    {
      'materialCode': '',
      'name': '',
      'unit': '',
      'unitPrice': '',
      'quantity': '',
    },
    {
      'materialCode': '',
      'name': '',
      'unit': '',
      'unitPrice': '',
      'quantity': '',
    },
  ];

  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2),
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
                _buildTableHeaderCell('Mã vật tư'),
                _buildTableHeaderCell('Tên'),
                _buildTableHeaderCell('ĐVT'),
                _buildTableHeaderCell('Đơn giá'),
                _buildTableHeaderCell('Định lượng'),
              ],
            ),
          ],
        ),
        ...costs.map((item) {
          return GestureDetector(
            onTap: () {
              // showCostDialog(context); // Nếu có dialog chi tiết
            },
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
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
                    _buildTableCell(item['materialCode']!),
                    _buildTableCell(item['name']!),
                    _buildTableCell(item['unit']!),
                    _buildTableCell(item['unitPrice']!),
                    _buildTableCell(item['quantity']!),
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
