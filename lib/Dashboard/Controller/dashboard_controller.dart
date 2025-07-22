import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_gemastik/Dashboard/Model/product_model.dart';

class DashboardController extends GetxController {
  CollectionReference products = FirebaseFirestore.instance.collection('products',
  );

  var productList = <ProductModel>[].obs;

  

  // Example method to fetch data or perform an action
  void fetchData() {
    products
        .get()
        .then((QuerySnapshot querySnapshot) {
          productList.value =
              querySnapshot.docs
                  .map((doc) {
                    try {
                      return ProductModel.fromJson(doc.id,
                        doc.data() as Map<String, dynamic>
                      );
                    } catch (e) {
                      print("Error parsing product data: $e");
                      return null;
                    }
                  })
                  .whereType<ProductModel>()
                  .toList();

          print("Products fetched successfully: ${productList.length} items");
        })
        .catchError((error) {
          print("Error fetching products: $error");
        });
  }

  void addProduct(ProductModel product) async {
    try {
      await products.add(product.toJson());
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
}
