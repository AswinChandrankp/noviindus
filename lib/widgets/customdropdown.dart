import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final bool isRequired;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final String title;
  final String? selectedValue;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    this.isRequired = false,
    this.validator,
    this.prefixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.hintStyle,
    this.textStyle,
    required this.title,
    this.selectedValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool isItemSelected = false;
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.title),
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            DropdownButtonFormField<String>(
              value: widget.selectedValue,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(217, 217, 217, 0.25),
                prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.focusedBorderColor ?? const Color.fromRGBO(217, 217, 217, 0.25),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? const Color.fromRGBO(217, 217, 217, 0.25),
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.errorBorderColor ?? Colors.red,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.errorBorderColor ?? Colors.red,
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                hintText: widget.hintText,
                hintStyle: widget.hintStyle,
              ),
              items: widget.items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: widget.textStyle),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  isItemSelected = newValue != null;
                  if (widget.onChanged != null) {
                    widget.onChanged!(newValue);
                  }
                });
              },
              validator: (value) {
                if (widget.validator != null) {
                  final error = widget.validator!(value);
                  setState(() {
                    showError = error != null;
                  });
                  return error;
                }
                setState(() {
                  showError = false;
                });
                return null;
              },
            ),
            if (widget.isRequired && !isItemSelected)
              const Positioned(
                right: 10,
                child: Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

