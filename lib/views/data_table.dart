import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class TDataTable extends StatelessWidget {
  const TDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(


            child: DataTable2(

                columns: const [
                  DataColumn2(label: Text('Column 1')),
                  DataColumn2(label: Text('Column 1')),
                  DataColumn2(label: Text('Column 1')),
                  DataColumn2(label: Text('Column 1')),
                ],

                rows: const [

                  DataRow(cells:
                  [
                    DataCell(Text('Cell1')),
                    DataCell(Text('Cell2')),
                    DataCell(Text('Cell3')),
                    DataCell(Text('Cell4')),
                  ]
                  ),
                  DataRow(cells:
                  [
                    DataCell(Text('Cell1')),
                    DataCell(Text('Cell2')),
                    DataCell(Text('Cell3')),
                    DataCell(Text('Cell4')),
                  ]
                  ),
                  DataRow(cells:
                  [
                    DataCell(Text('Cell1')),
                    DataCell(Text('Cell2')),
                    DataCell(Text('Cell3')),
                    DataCell(Text('Cell4')),
                  ]
                  ),
                  DataRow(cells:
                  [
                    DataCell(Text('Cell1')),
                    DataCell(Text('Cell2')),
                    DataCell(Text('Cell3')),
                    DataCell(Text('Cell4')),
                  ]
                  ),
                ]

            )),
      ),
    );
  }
}
