// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class OSearchDropDownController extends GetxController {
//   var filteredSuggestions = <String>[].obs;
//   var selectedValue = ''.obs;
//
//   void updateFilteredSuggestions(List<String> suggestions, String query) {
//     filteredSuggestions.value = suggestions
//         .where((element) => element.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
//
//   void updateSelectedValue(String value) {
//     selectedValue.value = value;
//   }
//
//   void resetToHint() {
//     selectedValue.value = '';
//   }
// }
//
// class OSearchDropDown extends StatelessWidget {
//   final List<String> suggestions;
//   final Function(String) onSelected;
//   final String hintText;
//
//   OSearchDropDown({
//     Key? key,
//     required this.suggestions,
//     required this.onSelected,
//     required this.hintText,
//   }) : super(key: key);
//
//   final OSearchDropDownController controller = Get.put(OSearchDropDownController());
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize the filtered suggestions
//     controller.filteredSuggestions.value = suggestions;
//
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Obx(
//             () => SearchField(
//           suggestionDirection: SuggestionDirection.flex,
//           onSearchTextChanged: (query) {
//             controller.updateFilteredSuggestions(suggestions, query);
//             return controller.filteredSuggestions
//                 .map(
//                   (e) => SearchFieldListItem<String>(
//                 e,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Text(
//                     e,
//                     style: const TextStyle(fontSize: 18, color: Colors.black),
//                   ),
//                 ),
//               ),
//             )
//                 .toList();
//           },
//           selectedValue: controller.selectedValue.value.isEmpty
//               ? null
//               : SearchFieldListItem<String>(controller.selectedValue.value),
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           validator: (value) {
//             if (value == null || !suggestions.contains(value.trim())) {
//               return 'Enter a valid product name';
//             }
//             return null;
//           },
//           onSubmit: (value) {
//             controller.updateSelectedValue(value);
//             onSelected(value);
//           },
//           autofocus: false,
//           key: const Key('searchfield'),
//           hint: hintText,
//           itemHeight: 50,
//           suggestions: controller.filteredSuggestions
//               .map(
//                 (e) => SearchFieldListItem<String>(
//               e,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Text(e, style: const TextStyle(fontSize: 18)),
//               ),
//             ),
//           )
//               .toList(),
//           onSuggestionTap: (SearchFieldListItem<String> suggestion) {
//             controller.updateSelectedValue(suggestion.searchKey);
//             onSelected(suggestion.searchKey);
//           },
//         ),
//       ),
//     );
//   }
// }
