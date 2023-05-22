import 'package:astarte/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFilter extends StatefulWidget {
  const DateFilter(
      {Key? key,
      required this.onStartDateSelected,
      required this.onEndDateSelected})
      : super(key: key);

  final Function(DateTime selectedStartDate) onStartDateSelected;
  final Function(DateTime selectedEndDate) onEndDateSelected;
  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  String selectedFarm = "";
  DateTime selectedStartDate = DateTime.now().subtract(Duration(days: 1));
  DateTime selectedEndDate = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedStartDate = await showDatePicker(
                context: context,
                initialDate: selectedStartDate != null &&
                        selectedStartDate.isAfter(selectedEndDate)
                    ? selectedEndDate
                    : selectedStartDate ?? DateTime.now(),
                firstDate: DateTime(2015),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: CustomColors.astarteRed,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedStartDate != null) {
                setState(() {
                  selectedStartDate = pickedStartDate;
                  widget.onStartDateSelected(selectedStartDate);
                });
              }
            },
            child: Text(
              'Start Date: ${selectedStartDate != null ? DateFormat('yyyy-MM-dd').format(selectedStartDate!) : 'Select'}',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedEndDate = await showDatePicker(
                context: context,
                initialDate: selectedEndDate ?? DateTime.now(),
                firstDate: selectedStartDate ?? DateTime(2015),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: CustomColors.astarteRed,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedEndDate != null) {
                setState(() {
                  selectedEndDate = pickedEndDate;
                  widget.onEndDateSelected(selectedEndDate);
                });
              }
            },
            child: Text(
              'End Date: ${selectedEndDate != null ? DateFormat('yyyy-MM-dd').format(selectedEndDate!) : 'Select'}',
            ),
          ),
        ],
      ),
    ]);
  }
}
