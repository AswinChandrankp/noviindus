

import 'package:flutter/material.dart';

enum PaymentOption { UPI, Cash, Card }

class PaymentOptionsWidget extends StatefulWidget {
  final ValueChanged<PaymentOption>? onChanged;

  const PaymentOptionsWidget({Key? key, this.onChanged}) : super(key: key);

  @override
  _PaymentOptionsWidgetState createState() => _PaymentOptionsWidgetState();
}

class _PaymentOptionsWidgetState extends State<PaymentOptionsWidget> {
  PaymentOption _selectedOption = PaymentOption.UPI;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (PaymentOption option in PaymentOption.values)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<PaymentOption>(
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value!;
                      widget.onChanged?.call(value);
                    });
                  },
                ),
                Text(option.toString().split('.').last),
                SizedBox(width: 16), 
              ],
            ),
        ],
      ),
    );
  }
}
