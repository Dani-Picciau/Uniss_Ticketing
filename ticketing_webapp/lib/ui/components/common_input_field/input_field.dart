import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class CommonInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final bool isPassword;

  const CommonInputField({
    super.key,
    required this.controller,
    required this.label,
    this.inputStyle,
    this.labelStyle,
    this.labelColor,
    this.isPassword = false,
  });

  @override
  State<CommonInputField> createState() => _CommonInputFieldState();
}

class _CommonInputFieldState extends State<CommonInputField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: widget.inputStyle,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: widget.labelStyle?.copyWith(
          color: widget.labelColor ?? context.colors.black,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => {
                  setState(() {
                    _obscureText = !_obscureText;
                  }),
                },
                icon: SvgPicture.asset(
                  _obscureText
                      ? MediaConstants.showPassword
                      : MediaConstants.hidePassword,
                  width: 22,
                  height: 22,
                ),
              )
            : null,
      ),
    );
  }
}
