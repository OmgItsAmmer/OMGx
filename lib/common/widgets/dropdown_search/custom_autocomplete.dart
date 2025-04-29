import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A custom implementation of the Autocomplete widget that provides better control
/// over the text field controller and selection behavior.
class CustomAutocomplete<T extends Object> extends StatelessWidget {
  /// Function to convert option object to display string
  final String Function(T) displayStringForOption;

  /// Function to build the custom field view
  final Widget Function(
          BuildContext, TextEditingController, FocusNode, VoidCallback)
      fieldViewBuilder;

  /// Function to filter options based on input
  final Iterable<T> Function(TextEditingValue) optionsBuilder;

  /// Function called when an option is selected
  final void Function(T)? onSelected;

  /// Maximum height of the options dropdown
  final double optionsMaxHeight;

  /// Direction in which the options list opens
  final OptionsViewOpenDirection optionsViewOpenDirection;

  /// Initial value for the text field
  final TextEditingValue? initialValue;

  /// Custom options view builder (optional)
  final Widget Function(BuildContext, void Function(T), Iterable<T>)?
      optionsViewBuilder;

  const CustomAutocomplete({
    Key? key,
    required this.displayStringForOption,
    required this.fieldViewBuilder,
    required this.optionsBuilder,
    this.onSelected,
    this.optionsMaxHeight = 200.0,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.initialValue,
    this.optionsViewBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: fieldViewBuilder,
      initialValue: initialValue,
      optionsBuilder: optionsBuilder,
      optionsViewOpenDirection: optionsViewOpenDirection,
      optionsViewBuilder: optionsViewBuilder ?? _defaultOptionsViewBuilder,
      onSelected: onSelected,
      // autoFlipDirection: true,
    );
  }

  Widget _defaultOptionsViewBuilder(
    BuildContext context,
    void Function(T) onSelected,
    Iterable<T> options,
  ) {
    final AlignmentDirectional optionsAlignment =
        switch (optionsViewOpenDirection) {
      OptionsViewOpenDirection.up => AlignmentDirectional.bottomStart,
      OptionsViewOpenDirection.down => AlignmentDirectional.topStart,
    };

    return Align(
      alignment: optionsAlignment,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: optionsMaxHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance.addPostFrameCallback(
                        (Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    }, debugLabel: 'CustomAutocomplete.ensureVisible');
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(displayStringForOption(option)),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
