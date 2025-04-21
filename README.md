# How to lazy load few rows in Flutter DataTable (SfDataGrid)?.

In this article, we will show you how to lazy load few rows in [Flutter DataTable](https://www.syncfusion.com/flutter-widgets/flutter-datagrid).

Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with all the required properties. Infinite scrolling or load more support, allows additional rows to be loaded as the grid reaches the bottom. When there's insufficient data to make the rows scrollable, you can add custom widgets such as a footer to enable lazy loading. In such cases, use the [SfDataGrid.footer](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid/footer.html) property. To determine when to enable the footer, check whether the number of rows exceeds the visible screen size.

```dart
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
```

You can download this example on [GitHub](https://github.com/SyncfusionExamples/How-to-lazy-load-with-few-rows-in-Flutter-DataTable).