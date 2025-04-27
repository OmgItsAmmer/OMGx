import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/loaders/tloaders.dart';
import 'custom_autocomplete.dart';

/// An improved autocomplete widget based on CustomAutocomplete that:
/// 1. Only displays options when user types something
/// 2. Automatically hides overlay when focus is lost
/// 3. Shows validation error when user enters text not in the options list
class ImprovedAutocomplete<T extends Object> extends StatefulWidget {
  /// The title/label text for the field
  final String titleText;

  /// The hint text for the field
  final String hintText;

  /// Function to convert an option to a display string
  final String Function(T) displayStringForOption;

  /// List of all available options
  final List<T> options;

  /// Controller for the text field
  final TextEditingController controller;

  /// Function called when an option is selected
  final Function(T)? onSelected;

  /// Function called when clear button is pressed
  final Function()? onClear;

  /// Function to handle invalid input (when entered text is not in options)
  /// If not provided, a default error message will be shown
  final Function(String)? onInvalidInput;

  /// Whether the field is read-only
  final bool readOnly;

  /// Custom validator function
  final String? Function(String?)? validator;

  const ImprovedAutocomplete({
    Key? key,
    required this.titleText,
    this.hintText = 'Select an option',
    required this.displayStringForOption,
    required this.options,
    required this.controller,
    this.onSelected,
    this.onClear,
    this.onInvalidInput,
    this.readOnly = false,
    this.validator,
  }) : super(key: key);

  @override
  State<ImprovedAutocomplete<T>> createState() =>
      _ImprovedAutocompleteState<T>();
}

class _ImprovedAutocompleteState<T extends Object>
    extends State<ImprovedAutocomplete<T>> {
  final FocusNode _focusNode = FocusNode();
  bool _isManualTextEntry = false;

  @override
  void initState() {
    super.initState();

    // Add listener to handle focus changes
    _focusNode.addListener(_onFocusChange);

    // Add listener to detect when text is manually entered
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isManualTextEntry) {
      _validateInput();
    }
  }

  void _onTextChanged() {
    _isManualTextEntry = true;
  }

  void _validateInput() {
    final currentText = widget.controller.text;
    if (currentText.isEmpty) return;

    // Check if the entered text matches any option
    bool isValid = widget.options.any((option) =>
        widget.displayStringForOption(option).toLowerCase() ==
        currentText.toLowerCase());

    if (!isValid) {
      if (widget.onInvalidInput != null) {
        widget.onInvalidInput!(currentText);
      } else {
        // Default error handling
        TLoader.errorSnackBar(
            title: 'Invalid Selection',
            message:
                '${widget.titleText} "${currentText}" not found in the list');

        // Clear the field
        widget.controller.clear();

        // Call onClear if provided
        if (widget.onClear != null) {
          widget.onClear!();
        }
      }
    }
  }

  void _clearText() {
    widget.controller.clear();
    _isManualTextEntry = false;

    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAutocomplete<T>(
      displayStringForOption: widget.displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return Iterable<T>.empty();
        }

        return widget.options.where((T option) {
          return widget
              .displayStringForOption(option)
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        // Keep controllers in sync
        if (widget.controller.text != textEditingController.text) {
          textEditingController.text = widget.controller.text;
        }

        // Set up a listener to keep the controllers in sync
        textEditingController.addListener(() {
          if (widget.controller.text != textEditingController.text) {
            widget.controller.text = textEditingController.text;
          }
        });

        return TextFormField(
          controller: textEditingController,
          focusNode: _focusNode,
          readOnly: widget.readOnly,
          validator: widget.validator,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
            _validateInput();
          },
          decoration: InputDecoration(
            labelText: widget.titleText,
            hintText: widget.hintText,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: _clearText,
            ),
          ),
        );
      },
      onSelected: (T selectedOption) {
        _isManualTextEntry = false;

        // Update the controller with the selected option
        widget.controller.text = widget.displayStringForOption(selectedOption);

        // Call onSelected if provided
        if (widget.onSelected != null) {
          widget.onSelected!(selectedOption);
        }
      },
    );
  }
}
