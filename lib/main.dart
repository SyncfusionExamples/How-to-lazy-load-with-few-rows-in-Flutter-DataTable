import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Syncfusion Flutter DataGrid',
      home: LoadMoreInfiniteScrollingDemo(),
    ),
  );
}

class LoadMoreInfiniteScrollingDemo extends StatefulWidget {
  const LoadMoreInfiniteScrollingDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadMoreInfiniteScrollingDemoState createState() =>
      _LoadMoreInfiniteScrollingDemoState();
}

class _LoadMoreInfiniteScrollingDemoState
    extends State<LoadMoreInfiniteScrollingDemo> {
  final List<Employee> _employees = <Employee>[];
  late EmployeeDataSource _employeeDataSource;
  bool isFooterEnabled = true;

  @override
  void initState() {
    _populateEmployeeData(6);
    _employeeDataSource = EmployeeDataSource(employees: _employees);
    super.initState();
  }

  void _updateFooterVisibility() {
    // Default row height in SfDataGrid.
    double rowHeight = 49;
    // Need to remove the header and the extra row height created.
    double availableHeight = MediaQuery.of(context).size.height - 200;
    double totalRowsHeight =
        (_employeeDataSource.effectiveRows.length) * rowHeight;
    setState(() {
      isFooterEnabled = totalRowsHeight < availableHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Syncfusion Flutter DataGrid')),
      body: SfDataGrid(
        source: _employeeDataSource,
        columnWidthMode: ColumnWidthMode.fill,
        footer:
            isFooterEnabled
                ? Container(
                  height: 60.0,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: BorderDirectional(
                      top: BorderSide(
                        width: 1.0,
                        color: Color.fromRGBO(0, 0, 0, 0.26),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    height: 36.0,
                    width: 142.0,
                    child: MaterialButton(
                      color: Colors.blue,
                      child: const Text(
                        'LOAD MORE',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _employeeDataSource._addMoreRows(10);
                        _employeeDataSource.notifyListeners();
                        _updateFooterVisibility();
                      },
                    ),
                  ),
                )
                : null,
        loadMoreViewBuilder: (BuildContext context, LoadMoreRows loadMoreRows) {
          Future<String> loadRows() async {
            await loadMoreRows();
            return Future<String>.value('Completed');
          }
      
          return FutureBuilder<String>(
            initialData: 'loading',
            future: loadRows(),
            builder: (context, snapShot) {
              if (snapShot.data == 'loading') {
                return Container(
                  height: 60.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: BorderDirectional(
                      top: BorderSide(
                        width: 1.0,
                        color: Color.fromRGBO(0, 0, 0, 0.26),
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              } else {
                return SizedBox.fromSize(size: Size.zero);
              }
            },
          );
        },
        columns: <GridColumn>[
          GridColumn(
            columnName: 'id',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('ID'),
            ),
          ),
          GridColumn(
            columnName: 'name',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Name'),
            ),
          ),
          GridColumn(
            columnName: 'designation',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Designation', overflow: TextOverflow.ellipsis),
            ),
          ),
          GridColumn(
            columnName: 'salary',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Salary'),
            ),
          ),
        ],
      ),
    );
  }

  void _populateEmployeeData(int count) {
    final Random random = Random();
    int startIndex = _employees.isNotEmpty ? _employees.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      _employees.add(
        Employee(
          1000 + i,
          _names[random.nextInt(_names.length - 1)],
          _designation[random.nextInt(_designation.length - 1)],
          10000 + random.nextInt(10000),
        ),
      );
    }
  }
}

final List<String> _names = <String>[
  'Welli',
  'Blonp',
  'Folko',
  'Furip',
  'Folig',
  'Picco',
  'Frans',
  'Warth',
  'Linod',
  'Simop',
  'Merep',
  'Riscu',
  'Seves',
  'Vaffe',
  'Alfki',
];

final List<String> _designation = <String>[
  'Lead',
  'Developer',
  'Manager',
  'Designer',
  'System ',
  'CEO',
];

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;

  final String name;

  final String designation;

  final int salary;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employees}) {
    _employeeData =
        employees
            .map<DataGridRow>(
              (e) => DataGridRow(
                cells: [
                  DataGridCell<int>(columnName: 'id', value: e.id),
                  DataGridCell<String>(columnName: 'name', value: e.name),
                  DataGridCell<String>(
                    columnName: 'designation',
                    value: e.designation,
                  ),
                  DataGridCell<int>(columnName: 'salary', value: e.salary),
                ],
              ),
            )
            .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  void _addMoreRows(int count) {
    final Random random = Random();
    int startIndex = _employeeData.isNotEmpty ? _employeeData.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      _employeeData.add(
        DataGridRow(
          cells: [
            DataGridCell<int>(columnName: 'id', value: 1000 + i),
            DataGridCell<String>(
              columnName: 'name',
              value: _names[random.nextInt(_names.length - 1)],
            ),
            DataGridCell<String>(
              columnName: 'designation',
              value: _designation[random.nextInt(_designation.length - 1)],
            ),
            DataGridCell<int>(
              columnName: 'salary',
              value: 10000 + random.nextInt(10000),
            ),
          ],
        ),
      );
    }
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(const Duration(seconds: 5));
    _addMoreRows(10);
    notifyListeners();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((e) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8.0),
              child: Text(e.value.toString()),
            );
          }).toList(),
    );
  }
}
