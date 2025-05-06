import 'package:flutter/material.dart';
import 'package:spa_app/pages/branch/cost_dialog.dart';

class ComboCosstScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const ComboCosstScreen({
    Key? key,
    required this.branch,
    required this.userData,
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return Scaffold(

    // === Nút Thêm ===
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: const EdgeInsets.all(24),
                                backgroundColor: Colors.transparent,
                                child: UnconstrainedBox(
                                  constrainedAxis: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                                      maxHeight: MediaQuery.of(context).size.height * 0.8, // 🧠 KHÔNG thể thiếu dòng này
                                    ),
                                    child: CostFormDialog(
                                      branch: branch,
                                      userData: userData,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
      },
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.add),
    ),

    // === Nền và nội dung chính nếu có thể bổ sung sau ===
    body: Stack(
      children: [
        Container(
          color: const Color(0xFFE8F9FB), // Nền
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
              'images/bg_spa_none.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Nội dung khác nếu cần
        Padding(
          padding: const EdgeInsets.only(top: 20), // đẩy bảng xuống dưới appbar
          child: _buildComboCostTable(context),
        ),
      ],
    ),
  );
}

Widget _buildComboCostTable(BuildContext context) {
  final List<Map<String, String>> comboCosts = [
    {
      'code': 'CB001',
      'price': '500,000',
      'otherCost': '50,000',
      'cost': '300,000',
      'costPercent': '60%',
      'materialCode': 'MT001',
      'unitPrice': '100,000',
      'quantity': '3',
    },
    {
      'code': 'CB002',
      'price': '600,000',
      'otherCost': '70,000',
      'cost': '350,000',
      'costPercent': '58%',
      'materialCode': 'MT002',
      'unitPrice': '120,000',
      'quantity': '3',
    },
    {
      'code': 'CB003',
      'price': '700,000',
      'otherCost': '80,000',
      'cost': '420,000',
      'costPercent': '60%',
      'materialCode': 'MT003',
      'unitPrice': '140,000',
      'quantity': '3',
    },
    {
      'code': 'CB004',
      'price': '800,000',
      'otherCost': '90,000',
      'cost': '500,000',
      'costPercent': '62%',
      'materialCode': 'MT004',
      'unitPrice': '160,000',
      'quantity': '3',
    },
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
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
                _buildTableHeaderCell('Mã'),
                _buildTableHeaderCell('Đơn giá bán'),
                _buildTableHeaderCell('Chi phí khác'),
                _buildTableHeaderCell('Cost'),
                _buildTableHeaderCell('%Cost'),
                _buildTableHeaderCell('Mã vật tư'),
                _buildTableHeaderCell('Đơn giá'),
                _buildTableHeaderCell('Định lượng'),
              ],
            ),
          ],
        ),
        ...comboCosts.map((item) {
          return GestureDetector(
            onTap: () {
              showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: const EdgeInsets.all(24),
                                backgroundColor: Colors.transparent,
                                child: UnconstrainedBox(
                                  constrainedAxis: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                                      maxHeight: MediaQuery.of(context).size.height * 0.8, // 🧠 KHÔNG thể thiếu dòng này
                                    ),
                                    child: CostFormDialog(
                                      branch: branch,
                                      userData: userData,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
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
                  _buildTableCell(item['code']!),
                  _buildTableCell(item['price']!),
                  _buildTableCell(item['otherCost']!),
                  _buildTableCell(item['cost']!),
                  _buildTableCell(item['costPercent']!),
                  _buildTableCell(item['materialCode']!),
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
