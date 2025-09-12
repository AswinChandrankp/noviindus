

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool isRequired;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? suffixIconTap;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final title ;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    this.isRequired = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconTap,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.hintStyle,
    this.textStyle,  this.title,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isTextEntered = false;
  bool showError = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_textChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textChanged);
    super.dispose();
  }

  void _textChanged() {
    setState(() {
      isTextEntered = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text( "${widget.title}",),
        ),

        Stack(
          alignment: Alignment.centerRight,
          children: [
            
            TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(217, 217, 217, 0.25),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon)
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? IconButton(
                        icon: Icon(widget.suffixIcon),
                        onPressed: widget.suffixIconTap,
                      )
                    : null,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.focusedBorderColor ?? Color.fromRGBO(217, 217, 217, 0.25),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Color.fromRGBO(217, 217, 217, 0.25),
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
              style: widget.textStyle,
            ),
            if (widget.isRequired && !isTextEntered)
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
