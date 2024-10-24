import 'package:flutter/material.dart';
import 'package:pesticides/Core/utils/colors.dart';
import '../../data/models/testing_data_table.dart';

class CustomeDateTable extends StatelessWidget {
  //todo get the date and make a copy of it so we can edit it later , sorting , modification and so on...
  List<DeviceId> data = List.from(deviceId);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: createColumns(),
          rows: createRow(),
        ),
      ),
    );
  }
  List<DataColumn> createColumns() {
    return [
      DataColumn(label: Text('DeviceID')),
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('Time')),
    ];
  }

  List<DataRow> createRow() {
    return data.map((e) {
      return DataRow(
        cells: [
          DataCell(Text(e.id.toString(),style: TextStyle(color: ColorManager.whiteColor),),),
          DataCell(Text(e.date.toString(),style: TextStyle(color: ColorManager.whiteColor),),),
          DataCell(Text(e.time.toString(),style: TextStyle(color: ColorManager.whiteColor),),),
        ],
      );
    }).toList();
  }
}
