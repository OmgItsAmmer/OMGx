import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

// GetX Controller to manage the state
class SearchFieldController extends GetxController {
  var suggestions = <String>[].obs; // Observable suggestions list
  var selectedValue = ''.obs; // Observable for the selected value

  void updateSuggestions(List<String> newSuggestions) {
    suggestions.value = newSuggestions;
  }

  void selectValue(String value) {
    selectedValue.value = value;
  }
}

// SearchFieldSample widget
class OSearchDropDown extends StatelessWidget {
  final SearchFieldController controller = Get.put(SearchFieldController()); // Initialize the controller
  final Function(String) onSelected;

  OSearchDropDown({
    Key? key,
    required List<String> suggestions,
    required this.onSelected,
  }) : super(key: key) {
    controller.updateSuggestions(suggestions); // Set initial suggestions
  }

  Widget searchChild(String text, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: isSelected ? Colors.green : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
              () => SearchField(
            suggestionDirection: SuggestionDirection.flex,
            onSearchTextChanged: (query) {
              final filteredSuggestions = controller.suggestions
                  .where((element) =>
                  element.toLowerCase().contains(query.toLowerCase()))
                  .toList();
              return filteredSuggestions
                  .map(
                    (e) => SearchFieldListItem<String>(
                  e,
                  child: searchChild(e),
                ),
              )
                  .toList();
            },
          selectedValue: controller.selectedValue.value.isEmpty
              ? null
                  : SearchFieldListItem<String>(controller.selectedValue.value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null ||
                  !controller.suggestions.contains(value.trim())) {
                return 'Enter a valid product name';
              }
              return null;
            },
            onSubmit: (value) {
              controller.selectValue(value);
              onSelected(value);
            },
            autofocus: false,
            key: const Key('searchfield'),
            hint: 'Search by product name',
            itemHeight: 50,
            scrollbarDecoration: ScrollbarDecoration(
              thickness: 12,
              radius: const Radius.circular(6),
              trackColor: Colors.grey,
              trackBorderColor: Colors.black,
              thumbColor: Colors.white,
            ),
            suggestionStyle: const TextStyle(fontSize: 18, color: Colors.black),
            suggestionItemDecoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            searchInputDecoration: SearchInputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
            ),
            suggestionsDecoration: SuggestionDecoration(
              elevation: 8.0,
              selectionColor: Colors.grey.shade100,
              hoverColor: Colors.purple.shade100,
              gradient: const LinearGradient(
                colors: [
                  Color(0xffffffff),
                  Color(0xFF000000),
                ],
                stops: [0.25, 0.75],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            suggestions: controller.suggestions
                .map(
                  (e) => SearchFieldListItem<String>(
                e,
                child: searchChild(e),
              ),
            )
                .toList(),
            suggestionState: Suggestion.expand,
            onSuggestionTap: (SearchFieldListItem<String> suggestion) {
              controller.selectValue(suggestion.searchKey);
              onSelected(suggestion.searchKey);
            },
          ),
        ),
      ),
    );
  }
}
