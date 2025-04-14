import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ODateRangePicker extends StatefulWidget {
  final ValueNotifier<DateTime?> startDateNotifier;
  final ValueNotifier<DateTime?> endDateNotifier;
  final ValueChanged<PickerDateRange?>? onRangeChanged;
  final double? height;
  final double? width;

  const ODateRangePicker({
    super.key,
    required this.startDateNotifier,
    required this.endDateNotifier,
    this.onRangeChanged,
    this.height = 250,
    this.width = 300,
  });

  @override
  State<ODateRangePicker> createState() => _ODateRangePickerState();
}

class _ODateRangePickerState extends State<ODateRangePicker> {
  @override
  void initState() {
    super.initState();
    // Optional: listen to changes in notifiers if needed
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: SfDateRangePicker(
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.range,
        initialSelectedRange: PickerDateRange(
          widget.startDateNotifier.value ?? DateTime.now(),
          widget.endDateNotifier.value ?? DateTime.now(),
        ),
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          if (args.value is PickerDateRange) {
            final PickerDateRange range = args.value;
            widget.startDateNotifier.value = range.startDate;
            widget.endDateNotifier.value = range.endDate;

            widget.onRangeChanged?.call(range);
          }
        },
      ),
    );
  }

  // Optional public getter
  PickerDateRange? get currentRange {
    final start = widget.startDateNotifier.value;
    final end = widget.endDateNotifier.value;
    return (start != null && end != null) ? PickerDateRange(start, end) : null;
  }
}
