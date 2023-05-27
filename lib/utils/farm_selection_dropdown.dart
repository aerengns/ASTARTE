import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/reports_util.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  const DropDown({Key? key, required this.farms, required this.onFarmSelected})
      : super(key: key);

  final List<Farm> farms;
  final Function(String farm) onFarmSelected;
  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String selectedFarm = "";
  late List<Farm> _farms;

  @override
  void initState() {
    super.initState();
    _farms = widget.farms;
  }

  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        "Select a Farm",
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Center(
        child: DropdownButton<String>(
          value: selectedFarm,
          icon: const Icon(
            Icons.arrow_drop_down_circle,
            color: CustomColors.astarteRed,
          ),
          onChanged: (value) {
            setState(() {
              selectedFarm = value!;
              widget.onFarmSelected(selectedFarm);
            });
          },
          items: _farms.map((farm) {
            return DropdownMenuItem<String>(
              value: farm.id,
              child: Text(farm.name),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}
