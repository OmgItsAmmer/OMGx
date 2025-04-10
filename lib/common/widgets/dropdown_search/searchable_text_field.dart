import 'package:flutter/material.dart';

class AutoCompleteTextField extends StatefulWidget {
  final String titleText;
  final List<String> optionList;
  final TextEditingController textController;
  final Function(String)? parameterFunc;

  const AutoCompleteTextField({
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
            constraints: const BoxConstraints(maxHeight: 200), // Limiting the height
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(), // Scroll when overflows
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

  void _clearText() {
    widget.textController.clear();
    widget.parameterFunc?.call(''); // Notify parent of the clear action
    _removeOverlay();
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
        TextFormField(
          key: _fieldKey,
          controller: widget.textController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.titleText,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, size: 18,),
              onPressed: _clearText, // Clears the text and closes the overlay
            ),
          ),
        ),
      ],
    );
  }
}
