import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/repositories/products/product_repository.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final productRepository = Get.put(ProductRepository());

//List of product Model
  RxList<ProductModel> allProducts = <ProductModel>[].obs;

  //List of names for searchbar
  RxList<String> productNames = <String>[].obs;

//Store selected Rows
  RxList<bool> selectedRows = <bool>[].obs;


  //Variables
  Rx<String> selectedProduct = ''.obs;

  @override
  void onInit() {
    fetchProducts();
    //_loadDummyData();

    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
        final product = await productRepository.fetchProducts();
        allProducts.assignAll(product);

        separateProductNames();


    } catch (e) {

      TLoader.errorsnackBar(title: 'ProductController',message: e.toString());
    }
  }

void separateProductNames()  {
    try {
      // Extract names
      final names = allProducts.map((product) => product.name).toList();

      // Ensure productNames is a list of strings
      productNames.assignAll(names);

    } catch (e) {
      // Handle errors
      TLoader.errorsnackBar(title: 'ProductController', message: e.toString());
    }
  }


  void _loadDummyData() {
    // Add dummy products to the list
    allProducts.addAll([
      ProductModel(
        productId: 1,
        description: 'hello',
        thumbnail: '',
        salePrice: '',
        brand: 'amm',
        isPopular: false,
        name: 'Product A',
        stockQuantity: 100,
        basePrice: 50.0.toString(),
        brandID: 1,
      ),
      ProductModel(
        productId: 1,
        description: 'hello',
        thumbnail: '',
        salePrice: '',
        brand: 'amm',
        isPopular: false,
        name: 'Product A',
        stockQuantity: 100,
        basePrice: 50.0.toString(),
        brandID: 1,
      ),
    ]);

    // Initialize the selected rows list with default values
    selectedRows.addAll(List<bool>.filled(allProducts.length, false));
  }
}
