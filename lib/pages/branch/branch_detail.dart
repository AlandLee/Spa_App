import 'package:flutter/material.dart';
import 'package:spa_app/pages/branch/order_screen.dart';
import 'package:spa_app/pages/branch/overview.dart';
import 'package:spa_app/pages/branch/export_screen.dart';
import 'package:spa_app/pages/branch/import_screen.dart';
import 'package:spa_app/pages/branch/adjust_screen.dart';
import 'package:spa_app/pages/branch/product_screen.dart';
import 'package:spa_app/pages/branch/structure_type_screen.dart';
import 'package:spa_app/pages/branch/timekeeping_screen.dart';
import 'package:spa_app/pages/branch/income_structure.dart';
import 'package:spa_app/pages/branch/payroll_screen.dart';
import 'package:spa_app/pages/branch/entity_screen.dart';
import 'package:spa_app/pages/branch/combo_cost_screen.dart';
import 'package:spa_app/pages/branch/warehouse_screen.dart';
import 'package:spa_app/pages/branch/customer_debt_screen.dart';
import 'package:spa_app/pages/branch/supplier_debt_screen.dart';
import 'package:spa_app/pages/branch/cash_flow_screen.dart';
import 'package:spa_app/pages/branch/student_registration.dart';
import 'package:spa_app/pages/branch/work_shifts.dart';

enum PageType {
  mainContent,
  orderScreen,
  exportScreen,
  importScreen,
  adjustScreen,
  productScreen,
  structureTypeScreen,
  timekeepingScreen,
  incomeStructureScreen,
  payrollScreen,
  entityScreen,
  comboCostScreen,
  warehouseScreen,
  customerDebtScreen,
  supplierDebtScreen,
  cashFlowScreen,
  studentRegistrationScreen,
  workshiftsScreen
}

class BranchDetailScreen extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Map<String, dynamic>? userData;

  const BranchDetailScreen({required this.branch, this.userData, Key? key}) : super(key: key);

  @override
  State<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> {
  PageType currentPage = PageType.mainContent;

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 236, 247, 248),
        child: Row(
          children: [
            // === SIDEBAR ===
            _buildSidebar(context),

            // === MAIN CONTENT ===
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (currentPage) {
      case PageType.orderScreen:
        return OrderScreen(
          branch: widget.branch,
          userData: widget.userData,
        );
      case PageType.exportScreen:
        return ExportScreen(
          branch: widget.branch,
          userData: widget.userData,
        );  
      case PageType.importScreen:
        return ImportScreen(
          branch: widget.branch,
          userData: widget.userData,
        );    
      case PageType.adjustScreen:
        return AdjustScreen(
          branch: widget.branch,
          userData: widget.userData,
        );   
      case PageType.productScreen:
        return ProductScreen(
          branch: widget.branch,
          userData: widget.userData,
        );     
      case PageType.structureTypeScreen:
        return StructureTypeScreen(
          branch: widget.branch,
          userData: widget.userData,
        );       
      case PageType.timekeepingScreen:
        return TimekeepingScreen(
          branch: widget.branch,
          userData: widget.userData,
        );  
      case PageType.incomeStructureScreen:
        return IncomeStructureScreen(
          branch: widget.branch,
          userData: widget.userData,
        );    
      case PageType.payrollScreen:
        return PayrollScreen(
          branch: widget.branch,
          userData: widget.userData,
        );      
      case PageType.entityScreen:
        return EntityScreen(
          branch: widget.branch,
          userData: widget.userData,
        );   
      case PageType.comboCostScreen:
        return ComboCosstScreen(
          branch: widget.branch,
          userData: widget.userData,
        );  
      case PageType.warehouseScreen:
        return WarehouseScreen(
          branch: widget.branch,
          userData: widget.userData,
        );  
      case PageType.customerDebtScreen:
        return CustomerDebtScreen(
          branch: widget.branch,
          userData: widget.userData,
        );    
      case PageType.supplierDebtScreen:
        return SupplierDebtScreen(
          branch: widget.branch,
          userData: widget.userData,
        );      
      case PageType.cashFlowScreen:
        return CashFlowScreen(
          branch: widget.branch,
          userData: widget.userData,
        );  
      case PageType.studentRegistrationScreen:
        return StudentRegistrationScreen(
          branch: widget.branch,
          userData: widget.userData,
        );       
      case PageType.workshiftsScreen:
        return WorkShiftsScreen(
          branch: widget.branch,
          userData: widget.userData,
        );    
      case PageType.mainContent:
        return MainContent(
          branch: widget.branch,
          userData: widget.userData,
        );
    }
  }

  Widget _buildSidebar(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width * 0.2,
      color: const Color(0xFFEFEFEF),
      child: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Text(
                widget.userData!['name'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              widget.userData!['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // HOME
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('HOME'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Tổng quan
          Container(
          color: currentPage == PageType.mainContent ? Colors.blue.shade100 : null,
          child: ListTile(
            leading: const Icon(Icons.view_quilt),
            title: const Text('Tổng quan'),
            onTap: () {
              setState(() {
                currentPage = PageType.mainContent;
              });
            },
          ),
        ),

          // PHIẾU
          ExpansionTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Phiếu'),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              Container(
              color: currentPage == PageType.orderScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Phiếu đặt hàng'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.orderScreen;
                  });
                },
              ),
            ),
              Container(
              color: currentPage == PageType.importScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Phiếu nhập'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.importScreen;
                  });
                },
              ),
            ),
              Container(
              color: currentPage == PageType.exportScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Phiếu xuất'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.exportScreen;
                  });
                },
              ),
            ),
              Container(
              color: currentPage == PageType.adjustScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Phiếu điều chỉnh'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.adjustScreen;
                  });
                },
              ),
            ),
              Container(
              color: currentPage == PageType.studentRegistrationScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Phiếu đăng ký học'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.studentRegistrationScreen;
                  });
                },
              ),
            ),
            ],
          ),

          // Các menu khác giữ nguyên
          //DANH MỤC
        ExpansionTile(
          leading: const Icon(Icons.folder_open),
          title: const Text('Danh mục'),
          childrenPadding: const EdgeInsets.only(left: 32),
          children: [
            Container(
              color: currentPage == PageType.entityScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Đối tượng'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.entityScreen;
                  });
                },
              ),
            ),
            Container(
              color: currentPage == PageType.productScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Hàng hoá, Dịch vụ'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.productScreen;
                  });
                },
              ),
            ),
            Container(
              color: currentPage == PageType.comboCostScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Combo Cost'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.comboCostScreen;
                  });
                },
              ),
            ),
            Container(
              color: currentPage == PageType.structureTypeScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Cơ cấu loại'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.structureTypeScreen;
                  });
                },
              ),
            ),
          ],
        ),

        // Các mục khác
        // CHẤM CÔNG
        ExpansionTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Chấm công'),
          childrenPadding: const EdgeInsets.only(left: 32),
          children: [
            Container(
              color: currentPage == PageType.timekeepingScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Chấm công'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.timekeepingScreen;
                  });
                },
              ),
            ),
            Container(
              color: currentPage == PageType.incomeStructureScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Cơ cấu thu nhập'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.incomeStructureScreen;
                  });
                },
              ),
            ),
            Container(
              color: currentPage == PageType.workshiftsScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Ký hiệu công, phân ca'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.workshiftsScreen;
                  });
                },
              ),
            ),
            Container(
              color: currentPage == PageType.payrollScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Bảng lương'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.payrollScreen;
                  });
                },
              ),
            ),
          ],
        ),

        // BÁO CÁO
        ExpansionTile(
          leading: const Icon(Icons.bar_chart),
          title: const Text('Báo cáo'),
          childrenPadding: const EdgeInsets.only(left: 32),
          children: [
            Container(
              color: currentPage == PageType.warehouseScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Kho'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.warehouseScreen;
                  });
                },
              ),
            ),
            Container(
              color: currentPage == PageType.customerDebtScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Công nợ khách hàng'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.customerDebtScreen;
                  });
                },
              ),
            ),
            Container(
              color: currentPage == PageType.supplierDebtScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Công nợ nhà cung cấp'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.supplierDebtScreen;
                  });
                },
              ),
            ),
          ],
        ),

        // DỮ LIỆU
        ExpansionTile(
          leading: const Icon(Icons.storage),
          title: const Text('Dữ liệu'),
          childrenPadding: const EdgeInsets.only(left: 32),
          children: [
            Container(
              color: currentPage == PageType.cashFlowScreen ? Colors.blue.shade100 : null,
              child: ListTile(
                title: const Text('Thu chi'),
                onTap: () {
                  setState(() {
                    currentPage = PageType.cashFlowScreen;
                  });
                },
              ),
            ),
          ],
        ),

        ListTile(
          leading: const Icon(Icons.build),
          title: const Text('Thiết lập'),
          onTap: () {},
        ),
        ],
      ),
    );
  }
}


 


