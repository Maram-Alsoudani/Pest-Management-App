import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final bool? isSecured;
  final Widget? suffixIcon;
  final BorderRadius? borderRadius;
  final bool enable;
  final Color? enabledBorderColor;
  final Color? disabledBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Function(String)? onChanged;

  CustomTextFormField({
    required this.hint,
    required this.validator,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isSecured = false,
    this.suffixIcon,
    this.borderRadius,
    this.enable = true,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.onChanged,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _isSecured;

  @override
  void initState() {
    super.initState();
    _isSecured = widget.isSecured ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: TextFormField(
        enabled: widget.enable,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        obscureText: _isSecured,
        cursorColor: ColorManager.blueColor,
        style: TextStyle(color: ColorManager.whiteColor),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: Theme.of(context).textTheme.titleSmall,
          suffixIcon: widget.isSecured == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isSecured = !_isSecured;
                    });
                  },
                  icon: Icon(
                    _isSecured ? Icons.visibility_off : Icons.visibility,
                    color: ColorManager.greyShade1,
                  ),
                )
              : widget.suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
            borderSide: BorderSide(
              width: 1,
              color: widget.enabledBorderColor ?? ColorManager.whiteColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
            borderSide: BorderSide(
              width: 1,
              color: widget.disabledBorderColor ?? ColorManager.greyShade6,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
            borderSide: BorderSide(
              width: 1,
              color: widget.focusedBorderColor ?? ColorManager.whiteColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
            borderSide: BorderSide(
              width: 1,
              color: widget.errorBorderColor ?? ColorManager.primaryColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
            borderSide: BorderSide(
              width: 1,
              color: widget.errorBorderColor ?? ColorManager.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
