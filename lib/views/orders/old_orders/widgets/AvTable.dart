// import 'package:ecommerce_dashboard/common/widgets/chips/choice_chip.dart';
// import 'package:ecommerce_dashboard/utils/constants/colors.dart';
// import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
// import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:vtable/vtable.dart';
//
// class AvTABLE extends StatelessWidget {
//   const AvTABLE({
//     super.key,
//     required this.items,
//     required this.columnKeys,
//     required this.enableDoubleTap,
//     required this.innerTableItems,
//     required this.innerColumnKeys, // Add keys for the inner table
//   });
//
//   final List<Map<String, dynamic>> items;
//   final List<String> columnKeys;
//   final bool enableDoubleTap; // Parameter to control double-tap behavior
//   final List<Map<String, dynamic>> innerTableItems; // Data for inner VTable
//   final List<String> innerColumnKeys; // Keys for the inner table columns
//
//   @override
//   Widget build(BuildContext context) {
//     // Dynamically create columns based on the main table keys
//     final columns = columnKeys.map((key) {
//       return VTableColumn(
//         label: key,
//         width: 100,
//         grow: 0.2,
//         transformFunction: (Map<String, dynamic>? row) =>
//         row?[key]?.toString() ?? 'N/A',
//         alignment: Alignment.centerLeft,
//       );
//     }).toList();
//
//     return Container(
//       width: TDeviceUtils.getScreenWidth(context),
//       height: TDeviceUtils.getAppBarHeight(),
//       child: VTable(
//         items: items,
//         columns: columns,
//
//         onDoubleTap: enableDoubleTap
//             ? (row) {
//           // Cast row to Map<String, dynamic> to access keys
//           final rowData = row as Map<String, dynamic>?;
//
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: const Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Order Details'),
//                   Icon(Iconsax.message, size: 30, color: TColors.primary),
//                 ],
//               ),
//               content: Container(
//                 width: 500, // Adjust width as needed
//                 height: 400, // Adjust height as needed
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                               'Order ID: ${rowData?['Order ID'] ?? 'Unknown'}'),
//                           Text(
//                               'Name: ${rowData?['Customer Name'] ?? 'Unknown'}'),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: TSizes.spaceBtwItems,
//                       ),
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           TChoiceChip(text: 'Pending', selected: true),
//                           SizedBox(
//                             width: TSizes.spaceBtwItems,
//                           ),
//                           TChoiceChip(text: 'Completed', selected: false),
//                           SizedBox(
//                             width: TSizes.spaceBtwItems,
//                           ),
//                           TChoiceChip(text: 'Cancelled', selected: false),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: TSizes.spaceBtwItems,
//                       ),
//                       SizedBox(
//                         width: 450, // Adjust width
//                         height: 250, // Adjust height
//                         child: VTable(
//                           items: innerTableItems, // Inner table data
//                           columns: innerColumnKeys.map((key) {
//                             return VTableColumn(
//                               label: key,
//                               width: 50,
//                               grow: 0.8,
//                               transformFunction:
//                                   (Map<String, dynamic>? row) =>
//                               row?[key]?.toString() ?? 'N/A',
//                               alignment: Alignment.centerLeft,
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Save'),
//                 ),
//               ],
//             ),
//           );
//         }
//             : null,
//       ),
//     );
//   }
// }
