import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noviindus/registration/models/branch_model.dart';
import 'package:noviindus/registration/models/treatment_model.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String title;
  final String? selectedValue;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool isRequired;
  final String hintText;
  final IconData? prefixIcon;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.title,
    this.selectedValue,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    required this.hintText,
    this.prefixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.hintStyle,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(217, 217, 217, 0.25),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            hintText: hintText,
            hintStyle: hintStyle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor ?? Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: focusedBorderColor ?? Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorBorderColor ?? Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorBorderColor ?? Colors.red, width: 2),
            ),
          ),
          style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
          icon: const Icon(Icons.arrow_drop_down),
          items: items.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: textStyle),
          )).toList(),
          onChanged: onChanged,
          validator: validator ??
              (value) {
                if (isRequired && (value == null || value.isEmpty)) {
                  return 'Please select an option';
                }
                return null;
              },
          isExpanded: true,
        ),
      ],
    );
  }
}



class BranchesDropdown extends StatelessWidget {
  final List<Branches> items;
  final String title;
  final Branches? selectedValue; 
  final void Function(Branches?)? onChanged; 
  final String? Function(Branches?)? validator; 
  final bool isRequired;
  final String hintText;
  final IconData? prefixIcon;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;

  const BranchesDropdown({
    Key? key,
    required this.items,
    required this.title,
    this.selectedValue,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    required this.hintText,
    this.prefixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.hintStyle,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<Branches>(
          value: selectedValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(217, 217, 217, 0.25),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            hintText: hintText,
            hintStyle: hintStyle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor ?? Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: focusedBorderColor ?? Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorBorderColor ?? Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorBorderColor ?? Colors.red, width: 2),
            ),
          ),
          style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
          icon: const Icon(Icons.arrow_drop_down),
          items: items.map((item) => DropdownMenuItem<Branches>(
            value: item,
            child: Text(item.name ?? '', style: textStyle),
          )).toList(),
          onChanged: onChanged,
          validator: validator ??
              (value) {
                if (isRequired && value == null) {
                  return 'Please select an option';
                }
                return null;
              },
          isExpanded: true,
        ),
      ],
    );
  }
}


class TreatmentsDropdown extends StatelessWidget {
  final List<Treatment> items;
  final String title;
  final Treatment? selectedValue; 
  final void Function(Treatment?)? onChanged; 
  final String? Function(Treatment?)? validator; 
  final bool isRequired;
  final String hintText;
  final IconData? prefixIcon;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;

  const TreatmentsDropdown({
    Key? key,
    required this.items,
    required this.title,
    this.selectedValue,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    required this.hintText,
    this.prefixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.hintStyle,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<Treatment>(
          value: selectedValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(217, 217, 217, 0.25),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            hintText: hintText,
            hintStyle: hintStyle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor ?? Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: focusedBorderColor ?? Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorBorderColor ?? Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorBorderColor ?? Colors.red, width: 2),
            ),
          ),
          style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
          icon: const Icon(Icons.arrow_drop_down),
          items: items.map((item) => DropdownMenuItem<Treatment>(
            value: item,
            child: Text(item.name ?? '', style: textStyle),
          )).toList(),
          onChanged: onChanged,
          validator: validator ??
              (value) {
                if (isRequired && value == null) {
                  return 'Please select an option';
                }
                return null;
              },
          isExpanded: true,
        ),
      ],
    );
  }
}



class DropdownTimePicker extends StatefulWidget {
  final String title;
  final String? selectedValue;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool isRequired;
  final String hintText;
  final IconData? prefixIcon;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final bool use24HourFormat;

  const DropdownTimePicker({
    Key? key,
    required this.title,
    this.selectedValue,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    required this.hintText,
    this.prefixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.hintStyle,
    this.textStyle,
    this.use24HourFormat = false,
  }) : super(key: key);

  @override
  State<DropdownTimePicker> createState() => _DropdownTimePickerState();
}

class _DropdownTimePickerState extends State<DropdownTimePicker> {
  late TextEditingController _hourController;
  late TextEditingController _minuteController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final initialTime = _parseInitialTime();
    _hourController = TextEditingController(
      text: initialTime != null
          ? widget.use24HourFormat
              ? initialTime.hour.toString().padLeft(2, '0')
              : (initialTime.hour % 12 == 0 ? 12 : initialTime.hour % 12).toString()
          : '',
    );
    _minuteController = TextEditingController(
      text: initialTime != null ? initialTime.minute.toString().padLeft(2, '0') : '',
    );
    _updateErrorText();
  }

  @override
  void didUpdateWidget(DropdownTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      final newTime = _parseInitialTime();
      _hourController.text = newTime != null
          ? widget.use24HourFormat
              ? newTime.hour.toString().padLeft(2, '0')
              : (newTime.hour % 12 == 0 ? 12 : newTime.hour % 12).toString()
          : '';
      _minuteController.text =
          newTime != null ? newTime.minute.toString().padLeft(2, '0') : '';
      _updateErrorText();
    }
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  // Format the selected time for display (supports 12/24-hour)
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return widget.use24HourFormat
        ? DateFormat('HH:mm').format(dateTime) // e.g., "15:30"
        : DateFormat.jm().format(dateTime); // e.g., "3:30 PM"
  }

  // Parse selectedValue to TimeOfDay for initial time picker value
  TimeOfDay? _parseInitialTime() {
    if (widget.selectedValue == null) return null;
    try {
      DateFormat format = widget.use24HourFormat ? DateFormat('HH:mm') : DateFormat.jm();
      final dateTime = format.parse(widget.selectedValue!);
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } catch (_) {
      return null;
    }
  }

  // Update error text based on validation
  void _updateErrorText() {
    if (widget.validator != null) {
      _errorText = widget.validator!(widget.selectedValue);
    } else if (widget.isRequired && (widget.selectedValue == null || widget.selectedValue!.isEmpty)) {
      _errorText = 'Please select a time';
    } else {
      _errorText = null;
    }
  }

  // Show time picker dialog
  Future<void> _showTimePicker(BuildContext context) async {
    final initialTime = _parseInitialTime() ?? TimeOfDay.now();
    final picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              // Uncomment and customize as needed:
              // hourMinuteTextStyle: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
              // dialHandColor: widget.focusedBorderColor ?? Colors.blue,
              // entryModeIconColor: widget.focusedBorderColor ?? Colors.blue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && widget.onChanged != null) {
      final formattedTime = _formatTime(picked);
      _hourController.text = widget.use24HourFormat
          ? picked.hour.toString().padLeft(2, '0')
          : (picked.hour % 12 == 0 ? 12 : picked.hour % 12).toString();
      _minuteController.text = picked.minute.toString().padLeft(2, '0');
      widget.onChanged!(formattedTime);
      setState(() {
        _updateErrorText();
      });
    }
  }

  // Input decoration for the time picker fields
  InputDecoration _buildInputDecoration(BuildContext context, String fieldType) {
    return InputDecoration(
      filled: true,
      suffixIcon: Icon(Icons.arrow_drop_down_sharp),
      fillColor: const Color.fromRGBO(217, 217, 217, 0.25),
      hintText: fieldType == 'hour' ? 'Hour' : 'minutes',
      hintStyle: widget.hintStyle,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: widget.borderColor ?? Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: widget.focusedBorderColor ?? Colors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: widget.errorBorderColor ?? Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: widget.errorBorderColor ?? Colors.red, width: 2),
      ),
      errorText: fieldType == 'hour' ? _errorText : null, // Show error only on hour field
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyLarge,
              semanticsLabel: '${widget.title}${widget.isRequired ? ' (required)' : ''}',
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                semanticsLabel: 'required',
              ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showTimePicker(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    decoration: _buildInputDecoration(context, 'hour'),
                    style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
                    controller: _hourController,
                    validator: widget.validator ??
                        (value) {
                          if (widget.isRequired && (value == null || value.isEmpty)) {
                            return 'Please select a time';
                          }
                          return null;
                        },
                    onChanged: (value) {
                      setState(() {
                        _updateErrorText();
                      });
                    },
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // const Text(':', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => _showTimePicker(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    decoration: _buildInputDecoration(context, 'minute'),
                    style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
                    controller: _minuteController,
                    onChanged: (value) {
                      setState(() {
                        _updateErrorText();
                      });
                    },
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // const SizedBox(width: 8),
            // if (!widget.use24HourFormat)
            //   Text(
            //     // _parseInitialTime()?.period == DayPeriod.am ? 'AM' : 'PM',
            //     style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
            //   ),
          ],
        ),
      ],
    );
  }
}