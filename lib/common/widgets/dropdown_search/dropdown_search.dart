import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DropDownSearch extends StatefulWidget {
  const DropDownSearch({
    super.key,
    required this.title,
    required this.textController,
    required this.items,
    required this.parameterFunc,
  });
  final String title;
  final TextEditingController? textController;
  final List<String>? items;
  final Function(String) parameterFunc;

  @override
  State<DropDownSearch> createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<DropDownSearch> with TickerProviderStateMixin {
  bool _isTapped = false;
  List<String> _filteredList = [];
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _filteredList = widget.items ?? [];
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      widget.textController?.text = _filteredList[index];
                      widget.parameterFunc(_filteredList[index]);
                      _removeOverlay();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        _filteredList[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry);
  }

  void _removeOverlay() {
    // Check if _overlayEntry exists and is mounted before removing
    if (_overlayEntry.mounted) {
      _overlayEntry.remove();
    }
    // Clear the reference to avoid reuse
    _overlayEntry = OverlayEntry(builder: (_) => Container());
    _isTapped = false;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, color: Color(0xFF858597)),
          ),
          const SizedBox(height: 5),
          TextFormField(
           // readOnly: true,
            controller: widget.textController,
            onChanged: (val) {
              setState(() {
                if (val.isEmpty) {
                  _filteredList = widget.items ?? [];
                } else {
                  _filteredList = widget.items
                      ?.where((item) => item.toLowerCase().contains(val.toLowerCase()))
                      .toList() ?? [];
                }
              });
            },

            style: const TextStyle(color: Colors.black, fontSize: 16.0),
            onTap: () {
              if (!_isTapped) {
                _showOverlay();
              } else {
                _removeOverlay();
              }
              _isTapped = !_isTapped;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.only(bottom: 10, left: 10),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.7)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.7  )),
              ),
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_isTapped) {
      _removeOverlay();
    }
    super.dispose();
  }
}

