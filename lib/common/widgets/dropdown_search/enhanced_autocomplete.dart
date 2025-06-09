import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../loaders/tloaders.dart';
import 'custom_autocomplete.dart';

/// An enhanced autocomplete widget that exactly matches the behavior of ProductSearchBar
/// in sale_product_bar.dart with additional error handling capabilities.
///
/// Key features:
/// 1. Shows overlay with options immediately on focus (for address, brand, category)
/// 2. Properly hides overlay when clicking elsewhere
/// 3. Shows validation errors for invalid entries
/// 4. Allows syncing with an external controller
class EnhancedAutocomplete<T extends Object> extends StatefulWidget {
  /// The label text for the field
  final String labelText;

  /// The hint text for the field
  final String hintText;

  /// Function that converts an object to its display string
  final String Function(T) displayStringForOption;

  /// List of all available options
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
    Key? key,
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
  }) : super(key: key);

  @override
  State<EnhancedAutocomplete<T>> createState() =>
      _EnhancedAutocompleteState<T>();
}

class _EnhancedAutocompleteState<T extends Object>
    extends State<EnhancedAutocomplete<T>> {
  late TextEditingController _innerController;
  final LayerLink _layerLink = LayerLink();
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _innerController = TextEditingController();
    _isMounted = true;

    // Listen to changes in the external controller
    if (widget.externalController != null) {
      widget.externalController!.addListener(_updateInnerFromExternal);
    }
  }

  // Method to update inner controller when external changes
  void _updateInnerFromExternal() {
    if (!_isMounted) return;

    if (widget.externalController != null &&
        _innerController.text != widget.externalController!.text) {
      // Need to use setState to update the UI
      setState(() {
        _innerController.text = widget.externalController!.text;
      });
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    if (widget.externalController != null) {
      widget.externalController!.removeListener(_updateInnerFromExternal);
    }
    if (widget.externalController == null) {
      _innerController.dispose();
    }
    super.dispose();
  }

  void _validateManualEntry(String text) {
    if (!_isMounted || text.isEmpty) return;

    bool isValid = widget.options.any((option) =>
        widget.displayStringForOption(option).toLowerCase() ==
        text.toLowerCase());

    if (!isValid) {
      TLoader.errorSnackBar(
          title: 'Invalid Selection',
          message: '${widget.labelText} "${text}" not found in the list');

      // Reset the field if needed
      if (_isMounted && widget.externalController != null) {
        widget.externalController!.clear();
      }

      // Call the manual text entry callback if provided
      if (_isMounted && widget.onManualTextEntry != null) {
        widget.onManualTextEntry!('');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAutocomplete<T>(
      displayStringForOption: widget.displayStringForOption,
      optionsViewBuilder: (BuildContext context, void Function(T) onSelected,
          Iterable<T> options) {
        final AlignmentDirectional optionsAlignment =
            AlignmentDirectional.topStart;

        return Align(
          alignment: optionsAlignment,
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200.0),
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
                      child: Text(widget.displayStringForOption(option)),
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
        // Store reference to the text controller
        _innerController = textEditingController;

        // This is crucial: Always ensure the internal controller matches the external
        // regardless of whether they're empty or not
        if (widget.externalController != null &&
            textEditingController.text != widget.externalController!.text) {
          // Use WidgetsBinding to avoid text input issues
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_isMounted) {
              textEditingController.text = widget.externalController!.text;
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: textEditingController.text.length));
            }
          });
        }

        // Set up a listener to keep the controllers in sync
        textEditingController.addListener(() {
          if (!_isMounted) return;

          final currentText = textEditingController.text;

          // Sync with external controller if provided
          if (widget.externalController != null) {
            widget.externalController!.text = currentText;
          }

          // Check if the text was manually edited and doesn't match the selected item
          if (widget.selectedItemName != null &&
              currentText != widget.selectedItemName!.value) {
            // Set flag to indicate manual text entry
            if (widget.isManualTextEntry != null) {
              widget.isManualTextEntry!.value = true;
            }

            // Call the manual text entry callback if provided
            if (widget.onManualTextEntry != null) {
              widget.onManualTextEntry!(currentText);
            }
          }
        });

        // Handle focus changes
        focusNode.addListener(() {
          if (!_isMounted) return;

          if (!focusNode.hasFocus &&
              widget.isManualTextEntry != null &&
              widget.isManualTextEntry!.value) {
            _validateManualEntry(textEditingController.text);
          }

          // Show options on focus for fields that need it, but avoid auto-selection
          if (focusNode.hasFocus &&
              widget.showOptionsOnFocus &&
              textEditingController.text.isEmpty &&
              widget.options.isNotEmpty) {
            // Instead of calling onFieldSubmitted immediately, we'll let the optionsBuilder
            // handle showing options naturally when the field is focused and empty
            // This avoids the auto-selection issue
          }
        });

        return CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            focusNode: focusNode,
            controller: textEditingController,
            validator: widget.validator,
            onTap: () {
              // Simplified onTap - let the optionsBuilder handle showing options
              // This prevents the auto-selection issue that was happening with onFieldSubmitted
            },
            onFieldSubmitted: (String value) {
              if (!_isMounted) return;

              onFieldSubmitted();
              if (widget.isManualTextEntry != null &&
                  widget.isManualTextEntry!.value) {
                _validateManualEntry(value);
              }
            },
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              suffixIcon: textEditingController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        if (!_isMounted) return;

                        textEditingController.clear();
                        if (widget.externalController != null) {
                          widget.externalController!.clear();
                        }
                        if (widget.selectedItemName != null) {
                          widget.selectedItemName!.value = '';
                        }
                        if (widget.selectedItemId != null) {
                          widget.selectedItemId!.value = -1;
                        }
                        if (widget.onManualTextEntry != null) {
                          widget.onManualTextEntry!('');
                        }
                      },
                    )
                  : null,
            ),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty && !widget.showOptionsOnFocus) {
          return Iterable<T>.empty();
        }

        // For fields that should show options on focus, show all options when empty
        if (textEditingValue.text.isEmpty && widget.showOptionsOnFocus) {
          return widget.options;
        }

        // Filter options based on the entered text
        return widget.options.where((T option) {
          return widget
              .displayStringForOption(option)
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (T selectedItem) {
        if (!_isMounted) return;

        // Update controllers and notifiers
        final String itemName = widget.displayStringForOption(selectedItem);

        if (widget.externalController != null) {
          widget.externalController!.text = itemName;
        }

        if (widget.selectedItemName != null) {
          widget.selectedItemName!.value = itemName;
        }

        if (widget.selectedItemId != null && widget.getItemId != null) {
          final itemId = widget.getItemId!(selectedItem) ?? -1;
          widget.selectedItemId!.value = itemId;
        }

        if (widget.isManualTextEntry != null) {
          widget.isManualTextEntry!.value = false;
        }

        // Call the selection callback if provided
        if (widget.onSelected != null) {
          widget.onSelected!(selectedItem);
        }
      },
    );
  }
}
