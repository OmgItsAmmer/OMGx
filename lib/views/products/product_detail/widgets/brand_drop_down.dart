// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../../../../controllers/brands/brand_controller.dart';
//
// class BrandDropdown extends StatelessWidget {
//   final BrandController _brandController = Get.put(BrandController());
//
//   BrandDropdown({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Dropdown for selecting a brand
//         GetBuilder<BrandController>(
//           builder: (controller) {
//             return DropdownButton<String>(
//               padding: EdgeInsets.zero, // Remove all padding
//               value: controller.selectedBrand.value.isEmpty
//                   ? null
//                   : controller.selectedBrand.value, // Selected brand
//               underline: const SizedBox.shrink(), // Remove the default underline
//               isExpanded: true, // Ensures proper alignment and resizing
//               isDense: true, // Makes the dropdown less tall vertically
//               items: controller.brands.map((String brand) {
//                 return DropdownMenuItem<String>(
//                   value: brand,
//                   child: Row(
//                     children: [
//                       const Icon(Iconsax.box, size: 18), // Add your desired icon here
//                       const SizedBox(width: 8), // Space between icon and text
//                       Text(
//                         brand,
//                         style: const TextStyle(),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               onChanged: (String? value) {
//                 controller.selectedBrand.value = value ?? ''; // Update the selected brand
//               },
//             );
//           },
//         ),
//         const SizedBox(height: 16), // Space between dropdown and "Add Brand" section
//
//         // Add New Brand Section
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _brandController.newBrandController,
//                 decoration: const InputDecoration(
//                   labelText: 'Add New Brand',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8), // Space between text field and button
//             ElevatedButton(
//               onPressed: () {
//                 // Add the new brand to the list
//                 _brandController.addBrand(_brandController.newBrandController.text);
//                 _brandController.newBrandController.clear(); // Clear the text field
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }