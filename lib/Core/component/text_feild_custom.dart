import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final Color? hintTextColor;
  final Function(String)? onChanged;
  final InputBorder? border;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
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
    this.hintTextColor,
    this.onChanged,
    this.border,
    this.focusNode,
    this.inputFormatters,
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
        style: const TextStyle(color: ColorManager.whiteColor),
        onChanged: widget.onChanged,
        focusNode: widget.focusNode,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: widget.hintTextColor ?? ColorManager.greyShade3,
              ),
          suffixIcon: widget.isSecured == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isSecured = !_isSecured;
                    });
                  },
                  icon: FaIcon(
                    _isSecured
                        ? FontAwesomeIcons.solidEyeSlash
                        : FontAwesomeIcons.solidEye,
                    color: ColorManager.greyShade1,
                  ),
                )
              : widget.suffixIcon,
          enabledBorder: widget.border ??
              OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.enabledBorderColor ?? ColorManager.whiteColor,
                ),
              ),
          disabledBorder: widget.border ??
              OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.disabledBorderColor ?? ColorManager.greyShade6,
                ),
              ),
          focusedBorder: widget.border ??
              OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.focusedBorderColor ?? ColorManager.primaryColor,
                ),
              ),
          errorBorder: widget.border ??
              OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.errorBorderColor ?? ColorManager.primaryColor,
                ),
              ),
          focusedErrorBorder: widget.border ??
              OutlineInputBorder(
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
