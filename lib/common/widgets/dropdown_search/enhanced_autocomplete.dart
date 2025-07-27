import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../loaders/tloaders.dart';
import 'custom_autocomplete.dart';

/// An enhanced autocomplete widget for GetX projects.
///
/// NOTE: If you pass reactive (Rx) values (like RxList) for [options],
/// you MUST wrap this widget in an Obx or GetBuilder in the parent widget.
/// This widget is stateless and will rebuild only when its parent rebuilds.
class EnhancedAutocomplete<T extends Object> extends StatelessWidget {
  /// The label text for the field
  final String labelText;

  /// The hint text for the field
  final String hintText;

  /// Function that converts an object to its display string
  final String Function(T) displayStringForOption;

  /// List of all available options (should be a normal List, or use Obx in parent for RxList)
  final List<T> options;

  /// External controller to sync with
  final TextEditingController? externalController;

  /// Flag to track if text was manually entered (GetX RxBool)
  final RxBool? isManualTextEntry;

  /// Value notifier for the selected item name (GetX Rx<String>)
  final Rx<String>? selectedItemName;

  /// Value notifier for the selected item ID (GetX Rx<int>)
  final Rx<int>? selectedItemId;

  /// Function to extract ID from an item
  final int? Function(T)? getItemId;

  /// Function called when an option is selected
  final Function(T)? onSelected;

  /// Function called after manual text entry
  final Function(String)? onManualTextEntry;

  /// Optional validator function
  final String? Function(String?)? validator;

  /// Whether to show options immediately on focus (for address, brand, category fields)
  final bool showOptionsOnFocus;

  const EnhancedAutocomplete({
    super.key,
    this.labelText = 'Item',
    this.hintText = 'Select an item',
    required this.displayStringForOption,
    required this.options,
    this.externalController,
    this.isManualTextEntry,
    this.selectedItemName,
    this.selectedItemId,
    this.getItemId,
    this.onSelected,
    this.onManualTextEntry,
    this.validator,
    this.showOptionsOnFocus = false,
  });

  void _validateManualEntry(BuildContext context, String text) {
    if (text.isEmpty) return;

    bool isValid = options.any((option) =>
        displayStringForOption(option).toLowerCase() == text.toLowerCase());

    if (!isValid) {
      TLoaders.errorSnackBar(
          title: 'Invalid Selection',
          message: ' $labelText "$text" not found in the list');

      // Reset the field if needed
      if (externalController != null) {
        externalController!.clear();
      }

      // Call the manual text entry callback if provided
      if (onManualTextEntry != null) {
        onManualTextEntry!('');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAutocomplete<T>(
      displayStringForOption: displayStringForOption,
      optionsViewBuilder: (BuildContext context, void Function(T) onSelected,
          Iterable<T> options) {
        const AlignmentDirectional optionsAlignment =
            AlignmentDirectional.topStart;

        return Align(
          alignment: optionsAlignment,
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200.0),
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
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(displayStringForOption(option)),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        // Only sync from external controller on initial build, not during typing
        if (externalController != null &&
            textEditingController.text.isEmpty &&
            externalController!.text.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            textEditingController.text = externalController!.text;
            textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: textEditingController.text.length));
          });
        }

        textEditingController.addListener(() {
          final currentText = textEditingController.text;

          // Sync with external controller if provided
          if (externalController != null) {
            externalController!.text = currentText;
          }

          // Check if the text was manually edited and doesn't match the selected item
          if (selectedItemName != null &&
              currentText != selectedItemName!.value) {
            // Set flag to indicate manual text entry
            if (isManualTextEntry != null) {
              isManualTextEntry!.value = true;
            }

            // Call the manual text entry callback if provided
            if (onManualTextEntry != null) {
              onManualTextEntry!(currentText);
            }
          }
        });

        focusNode.addListener(() {
          if (!focusNode.hasFocus &&
              isManualTextEntry != null &&
              isManualTextEntry!.value) {
            _validateManualEntry(context, textEditingController.text);
          }
        });

        return CompositedTransformTarget(
          link: LayerLink(),
          child: TextFormField(
            focusNode: focusNode,
            controller: textEditingController,
            validator: validator,
            onTap: () {},
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
              if (isManualTextEntry != null && isManualTextEntry!.value) {
                _validateManualEntry(context, value);
              }
            },
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              suffixIcon: textEditingController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        textEditingController.clear();
                        if (externalController != null) {
                          externalController!.clear();
                        }
                        if (selectedItemName != null) {
                          selectedItemName!.value = '';
                        }
                        if (selectedItemId != null) {
                          selectedItemId!.value = -1;
                        }
                        if (onManualTextEntry != null) {
                          onManualTextEntry!('');
                        }
                      },
                    )
                  : null,
            ),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty && !showOptionsOnFocus) {
          return Iterable<T>.empty();
        }

        // For fields that should show options on focus, show all options when empty
        if (textEditingValue.text.isEmpty && showOptionsOnFocus) {
          return options;
        }

        // Filter options based on the entered text
        return options.where((T option) {
          return displayStringForOption(option)
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (T selectedItem) {
        final String itemName = displayStringForOption(selectedItem);

        if (externalController != null) {
          externalController!.text = itemName;
        }

        if (selectedItemName != null) {
          selectedItemName!.value = itemName;
        }

        if (selectedItemId != null && getItemId != null) {
          final itemId = getItemId!(selectedItem) ?? -1;
          selectedItemId!.value = itemId;
        }

        if (isManualTextEntry != null) {
          isManualTextEntry!.value = false;
        }

        // Call the selection callback if provided
        if (onSelected != null) {
          onSelected!(selectedItem);
        }
      },
    );
  }
}
