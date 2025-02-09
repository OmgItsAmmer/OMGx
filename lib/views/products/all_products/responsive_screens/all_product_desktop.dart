import 'dart:io';

import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../Models/products/product_model.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../routes/routes.dart';
import '../table/product_table.dart';
import 'package:pdf/widgets.dart' as pw;

class AllProductDesktopScreen extends StatelessWidget {
  const AllProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return   Expanded(
      child: SizedBox(
        // height: 900,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Products',style: Theme.of(context).textTheme.headlineMedium ,),
                const SizedBox(height: TSizes.spaceBtwSections,),

                //Bread Crumbs

                //Table Body
                 TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: TSizes.buttonWidth*1.5,
                      child: ElevatedButton(onPressed: (){
                        productController.cleanProductDetail();
                        Get.toNamed(TRoutes.productsDetail);
                      }, child:  Text('Add Products',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white) ,),),),
                      SizedBox(width: TSizes.buttonWidth*1.5,
                        child: ElevatedButton(onPressed: (){
                          _exportToPdf(productController.allProducts);
                        }, child:  Text('Export',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white) ,),),),
                      SizedBox(width: 500 ,
                        child: TextFormField(
                          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal),hintText: 'Search Anything'),
                        ) ,
                      )
                    ],
                  ),
                    const SizedBox(height: TSizes.spaceBtwSections,),

                    //Table body
                    const ProductTable()


                  ],
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _exportToPdf(List<ProductModel> products) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Product Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                data: _buildTableData(products),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    // Get the directory for saving the PDF
    final directory = await getDownloadsDirectory(); // Saves to the Downloads folder
    if (directory == null) {
      Get.snackbar('Error', 'Could not access downloads directory');
      return;
    }

    // Define the file path
    final filePath = '${directory.path}/product_report.pdf';

    // Save the PDF file
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Show a success message
    Get.snackbar('Success', 'PDF saved to ${file.path}');
  }

  List<List<String>> _buildTableData(List<ProductModel> products) {
    // Add headers
    List<List<String>> tableData = [
      ['Product', 'Price', 'Sold', 'Brand'],
    ];

    // Add rows
    for (var product in products) {
      tableData.add([
        product.name.toString(),
        product.basePrice.toString(),
        product.stockQuantity.toString(),
        product.brandID.toString(), // TODO: Replace with brand name if available
      ]);
    }

    return tableData;
  }
}

