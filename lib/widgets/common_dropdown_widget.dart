import 'package:flutter/material.dart';

class CommonDropDownWidget extends StatelessWidget {
  const CommonDropDownWidget({
    Key? key,
    required this.heading,
    required this.hint,
    required this.value,
    required this.itemList,
    required this.onChanged,
  }) : super(key: key);

  final String heading;
  final String hint;
  final String? value;
  final List<String> itemList;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
        ),
        const SizedBox(height: 8),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField(
            isExpanded: true,
            value: value,
            hint: Text(hint),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 0,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(width: .5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(width: .5)),
            ),
            onChanged: (String? value) => onChanged(value),
            validator: (value) => value == null ? "Select something" : null,
            items: itemList.map((String val) {
              return DropdownMenuItem(
                value: val,
                child: Text(
                  val,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
