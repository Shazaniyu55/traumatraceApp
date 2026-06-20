// ignore_for_file: sized_box_for_whitespace, file_names, deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trauma/core/constant/colors.dart';

class InputFields extends StatelessWidget {
  final String headerText;
  final String hintText;
  final bool hasHeader;
  final TextEditingController? textController;
  final bool? isEditable;
  final Widget? suffixIcon;
  final Function? onChange;
  final TextInputType? inputType;

  const InputFields(
      {Key? key,
      required this.headerText,
      required this.hintText,
      required this.hasHeader,
      this.textController,
      this.isEditable,
      this.suffixIcon,
      this.inputType,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(),
          child: Text(
            headerText,
            style: TextStyle(
              color: placeholderColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'sfpro',
            ),
          ),
        ),
        TextField(
          cursorColor: primaryColor,
          cursorHeight: 20,
          controller: textController,
          enabled: isEditable,
          keyboardType: inputType ?? TextInputType.text,
          inputFormatters: [
            inputType == null
                ? LengthLimitingTextInputFormatter(
                    headerText.contains('Name') ? 18 : 50)
                : FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))
          ],
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'sfpro',
              color: inputFieldTextColor),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'sfpro',
                  color
                      : placeholderColor),
              filled: true,
              fillColor: inputFieldBackgroundColor,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cardColor, width: 0.1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cardColor, width: 0.1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: cardColor, width: 0.1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: cardColor, width: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: suffixIcon ?? const SizedBox()),
          onChanged: (value) {
            onChange!.call(value);
          },
        ),
      ],
    );
  }
}

class InputFieldPassword extends StatefulWidget {
  final String headerText;
  final String hintText;
  final TextEditingController? textController;
  final bool? isEditable;
  final Function onChange;
  final String? svg;

  const InputFieldPassword({
    Key? key,
    required this.headerText,
    required this.hintText,
    required this.textController,
    required this.onChange,
    this.isEditable,
    this.svg,
  }) : super(key: key);

  @override
  State<InputFieldPassword> createState() => _InputFieldPasswordState();
}

class _InputFieldPasswordState extends State<InputFieldPassword> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Text(
            widget.headerText,
            style: TextStyle(
              color: placeholderColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'sfpro',
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 58,
                decoration: BoxDecoration(
                  color: bg2CintainerColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
                child: Center(
                  child: Image.asset(
                    'images/${widget.svg}.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: TextField(
                  cursorColor: primaryColor,
                  cursorHeight: 20,
                  enabled: widget.isEditable,
                  onChanged: (val) {
                    widget.onChange.call(val);
                  },
                  style: TextStyle(color: inputFieldTextColor),
                  controller: widget.textController,
                  obscureText: _visible,
                  decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'sfpro',
                          color: placeholderColor),
                      filled: true,
                      //<-- SEE HERE
                      fillColor: inputFieldBackgroundColor,
                      //focusColor: activeInputColor,
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor, width: 0.1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor, width: 0.1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor, width: 0.1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: cardColor, width: 0.1),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                              !_visible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: primaryColor),
                          onPressed: () {
                            setState(() {
                              _visible = !_visible;
                            });
                          })),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

TextStyle defaultBtnStyle =
    TextStyle(color: btnTxtColor, fontSize: 18, fontFamily: 'sfpro');

class InputFieldsWithSeparateIcon extends StatelessWidget {
  final String headerText;
  final String hintText;
  final bool hasHeader;
  final TextEditingController? textController;
  final bool? isEditable;
  final Widget? suffixIcon;
  final Function? onChange;
  final String? svg;
  final TextInputType? inputType;

  const InputFieldsWithSeparateIcon(
      {Key? key,
      required this.headerText,
      required this.hintText,
      required this.hasHeader,
      this.textController,
      this.isEditable,
      this.suffixIcon,
      this.svg,
      this.inputType,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Text(
            headerText,
            style: TextStyle(
              color: placeholderColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'sfpro',
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 58,
                decoration: BoxDecoration(
                  color: bg2CintainerColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
                child: Center(
                  child: Image.asset(
                    'images/$svg.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: TextField(
                  cursorColor: primaryColor,
                  cursorHeight: 20,
                  controller: textController,
                  enabled: isEditable,
                  keyboardType: inputType ?? TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        headerText.contains('Name') ? 100 : 100),
                  ],
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'sfpro',
                      color: inputFieldTextColor),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'sfpro',
                          color: placeholderColor),
                      filled: true,
                      fillColor: inputFieldBackgroundColor,
                      hintText: hintText,
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor, width: 0.1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor, width: 0.1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor, width: 0.1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: cardColor, width: 0.1),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      suffixIcon: suffixIcon ?? const SizedBox()),
                  onChanged: (value) {
                    onChange?.call(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

RegExp lowerCase = RegExp(r"(?=.*[a-z])\w+");
RegExp upperCase = RegExp(r"(?=.*[A-Z])\w+");
RegExp containsNumber = RegExp(r"(?=.*?[0-9])");
RegExp hasSpecialCharacters =
    RegExp(r"[ !@#$%^&*()_+\-=\[\]{};':" "\\|,.<>/?]");
