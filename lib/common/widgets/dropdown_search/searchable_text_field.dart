import 'package:flutter/material.dart';

class AutoCompleteTextField extends StatefulWidget {
  final String titleText;
  final List<String> optionList;
  final TextEditingController textController;
  final Function(String)? parameterFunc;

  AutoCompleteTextField({
    required this.titleText,
    required this.optionList,
    required this.textController,
    this.parameterFunc,
    Key? key,
  }) : super(key: key);

  @override
  _AutoCompleteTextFieldState createState() => _AutoCompleteTextFieldState();
}

class _AutoCompleteTextFieldState extends State<AutoCompleteTextField> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    if (_overlayEntry != null) _removeOverlay();

    final RenderBox renderBox =
        _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final filteredOptions = widget.optionList
        .where((option) => option
            .toLowerCase()
            .contains(widget.textController.text.toLowerCase()))
        .toList();

    if (filteredOptions.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + renderBox.size.height,
        width: renderBox.size.width,
        child: Material(
          elevation: 4.0,
          child: Container(
            color: Colors.white,
            child: ListView(
              shrinkWrap: true,
              children: filteredOptions
                  .map((option) => ListTile(
                        title: Text(option),
                        onTap: () {
                          widget.textController.text = option;
                          widget.parameterFunc?.call(option);
                          _removeOverlay();
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(widget.titleText,
        //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
       // SizedBox(height: 8),
        TextFormField(
          key: _fieldKey,
          controller: widget.textController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.titleText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
