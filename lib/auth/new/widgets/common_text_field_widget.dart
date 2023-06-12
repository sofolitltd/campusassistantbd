import 'package:flutter/material.dart';

class CommonTextFieldWidget extends StatefulWidget {
  const CommonTextFieldWidget({
    Key? key,
    required this.controller,
    required this.heading,
    required this.hintText,
    required this.keyboardType,
    required this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.textCapitalization,
  }) : super(key: key);

  final TextEditingController controller;
  final String heading;
  final String hintText;
  final TextInputType keyboardType;
  final Function(String?) validator;
  final bool? obscureText;
  final bool? enabled;
  final TextCapitalization? textCapitalization;

  @override
  State<CommonTextFieldWidget> createState() => _CommonTextFieldWidgetState();
}

class _CommonTextFieldWidgetState extends State<CommonTextFieldWidget> {
  bool? _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.heading,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization == null
              ? TextCapitalization.none
              : widget.textCapitalization!,
          obscureText: _obscureText!,
          validator: (value) => widget.validator(value),
          style: TextStyle(
            color: widget.enabled! ? null : Colors.grey,
          ),
          decoration: InputDecoration(
            filled: widget.enabled! ? false : true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            hintText: widget.hintText,
            // prefixIcon: const Icon(Icons.mail_outline_outlined),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(width: .5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(width: .5)),
            suffixIcon: widget.obscureText!
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText!;
                      });
                    },
                    icon: Icon(
                      _obscureText!
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                      color: Colors.black54,
                    ),
                  )
                : null,
          ),
          enabled: widget.enabled!,
        ),
      ],
    );
  }
}
