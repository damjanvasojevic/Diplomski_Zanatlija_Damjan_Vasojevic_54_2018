import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class CommonActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onAction;
  final Color? customColor;
  const CommonActionButton(
      {required this.onAction,
      this.customColor,
      required this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onAction,
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor ?? Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          ).copyWith(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: Text(title),
        ),
      ),
    );
  }
}

class CommonTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool obscureText;
  final bool isDatePicker;
  final bool isPriceText;
  final TextInputType keyboardType;
  final List<String> locations;
  final bool disableCopyPaste;
  final bool isRichText;
  final bool isImagePicker;

  const CommonTextField(
    this.title,
    this.controller, {
    this.obscureText = false,
    this.isDatePicker = false,
    this.keyboardType = TextInputType.text,
    this.locations = const [],
    this.disableCopyPaste = false,
    this.isPriceText = false,
    this.isRichText = false,
    this.isImagePicker = false,
    super.key,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _isObscured = true;
  bool get shouldObscureText => widget.obscureText && _isObscured;

  void _selectDate(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final DateTime currentDate = widget.controller.text.isNotEmpty
        ? dateFormat.parse(widget.controller.text)
        : DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  initialDateTime: currentDate,
                  minimumYear: 1900,
                  maximumDate: currentDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDateTime) {
                    widget.controller.text = dateFormat.format(newDateTime);
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectLocation(String? location) {
    setState(() {
      widget.controller.text = location ?? '';
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.controller.text = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.935,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: widget.controller,
          obscureText: shouldObscureText,
          textAlign: TextAlign.justify,
          keyboardType: widget.keyboardType,
          readOnly: widget.disableCopyPaste,
          maxLines: widget.obscureText ? 1 : null,
          minLines: widget.isRichText ? 4 : 1,
          onTap: () {
            if (widget.disableCopyPaste) {
              FocusScope.of(context).requestFocus(FocusNode());
            } else if (widget.isImagePicker) {
              _pickImage();
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color(0xff787878),
                width: 2.0,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            hintText: widget.title,
            hintStyle: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: Color(0xff515151),
            ),
            suffixIcon: widget.isDatePicker
                ? IconButton(
                    icon: const Icon(Icons.calendar_month_outlined,
                        color: Colors.grey),
                    onPressed: () => _selectDate(context),
                  )
                : widget.isPriceText
                    ? IconButton(
                        icon: const Icon(Icons.euro, color: Colors.grey),
                        onPressed: () {},
                      )
                    : (widget.obscureText
                        ? IconButton(
                            icon: Icon(
                              shouldObscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          )
                        : widget.locations.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: Colors.grey),
                                onPressed: () {
                                  // Show the dropdown
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Select option'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: widget.locations
                                                .map((location) {
                                              return GestureDetector(
                                                onTap: () {
                                                  _selectLocation(location);
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(location),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            : null),
          ),
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
