// import 'package:ecommerce_dashboard/utils/constants/colors.dart';
// import 'package:flutter/material.dart';
// import '../../common/widgets/appbar/appbar.dart';
//
// class CategoryScreen extends StatelessWidget {
//   const CategoryScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const TAppBar(
//         title: Text(
//           'Category',
//           style: TextStyle(
//             fontSize: 25, // Set the desired font size
//           ),
//         ),
//         showBackArrow: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: Material(
//           color: TColors.pureBlack,
//           borderRadius: BorderRadius.circular(20),
//           child: Container(
//             decoration: BoxDecoration(
//               color: TColors.pureBlack,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.white.withValues(alpha: 0.2), // Shadow color
//                   spreadRadius: 5, // Spread of the shadow
//                   blurRadius: 10, // Blur intensity
//                   offset: const Offset(
//                       0, 5), // Offset for horizontal and vertical shadow
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 //  const SizedBox(height: TSizes.spaceBtwInputFields,),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20.0, right: 20.0),
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: SizedBox(
//                       width: 300,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           //  Get.to(() => AddBrandForm(formTitle: 'Add Category'));
//                         },
//                         child: const Text('Add Category'),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // new table here
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
