import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
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
  final parameterFunc;

  @override
  State<DropDownSearch> createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<DropDownSearch> with TickerProviderStateMixin {
  bool _isTapped = false;
  List<String> _filteredList = [];
  List<String> _subFilteredList = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _filteredList = widget.items!;
    _subFilteredList = _filteredList;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, color: Color(0xFF858597)),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                TextFormField(

                  controller: widget.textController,
                  onChanged: (val) {
                    setState(() {
                      _filteredList = _subFilteredList
                          .where((element) => element.toLowerCase().contains(
                          widget.textController!.text.toLowerCase()))
                          .toList();

                    });
                  },
                  validator: (val) =>
                  val!.isEmpty ? 'Field can\'t be empty' : null,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  onTap: () {
                    setState(() {
                      _isTapped = !_isTapped;

                    });
                    _isTapped
                        ? _animationController.forward()
                        : _animationController.reverse();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: const TextStyle(fontSize: 0.01),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        style: BorderStyle.solid,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 10, left: 10),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.7),
                            width: 0.8)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.7),
                            width: 0.8)),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.7), width: 0.8),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down, size: 25),
                    isDense: true,
                  ),
                ),
                // Animated dropdown list
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SizeTransition(
                      sizeFactor: _animationController,
                      axisAlignment: -1.0,
                      child: _isTapped && _filteredList.isNotEmpty
                          ? Container(
                        height: 150.0,
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                          itemCount: _filteredList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() => _isTapped = !_isTapped);
                                widget.textController!.text =
                                _filteredList[index];
                                //another function in parameter
                                widget.parameterFunc(widget.textController!.text);
                              //  TLoader.successSnackBar(title: widget.textController!.text);

                                _animationController.reverse();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  _filteredList[index],
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          )
        ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
