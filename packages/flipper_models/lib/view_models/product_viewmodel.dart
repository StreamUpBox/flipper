library flipper_models;

import 'package:flipper/routes.router.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/color.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/product_mock.dart';
import 'package:flipper_models/variation.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:uuid/uuid.dart';

import 'package:flipper_services/constants.dart';

class ProductViewModel extends ReactiveViewModel {
  final AppService _appService = locator<AppService>();

  final ProductService productService = locator<ProductService>();

  get products => productService.products;

  List<PColor> get colors => _appService.colors;

  List<Unit> get units => _appService.units;

  get categories => _appService.categories;

  get product => productService.product;

  String? _name;

  get name => _name;

  get currentColor => _appService.currentColor;

  List<Variation>? get variants => productService.variants;

  Future<void> loadProducts() async {
    await productService.loadProducts();
  }

  /// Create a temporal product to use during this session of product creation
  /// the same product will be use if it is still temp product
  ///
  Future<int> createTemporalProduct() async {
    final List<Product> isTemp = await ProxyService.api.isTempProductExist();
    if (isTemp.isEmpty) {
      Product product =
          await ProxyService.api.createProduct(product: productMock);
      productService.variantsProduct(productId: product.id);

      productService.setCurrentProduct(product: product);
      notifyListeners();
      return product.id;
    }
    // ProxyService.api.delete(id: isTemp[0].id);
    // return "d";
    productService.setCurrentProduct(product: isTemp[0]);
    productService.variantsProduct(productId: isTemp[0].id);

    return isTemp[0].id;
  }

  void setName({String? name}) {
    _name = name;
    final cleaned = name?.trim();
    _lock = cleaned?.length == null || cleaned?.length == 0;
    notifyListeners();
  }

  bool _lock = false;
  bool get lock => _lock;

  void loadCategories() {
    _appService.loadCategories();
  }

  void loadUnits() {
    _appService.loadUnits();
  }

  void loadColors() {
    _appService.loadColors();
  }

  ///create a new category and refresh list of categories
  Future<void> createCategory() async {
    final int? userId = ProxyService.box.read(key: 'userId');
    final int? branchId = ProxyService.box.read(key: 'branchId');
    final categoryId = DateTime.now().millisecondsSinceEpoch;
    final Category category = new Category(
      id: categoryId,
      active: true,
      table: AppTables.category,
      focused: false,
      name: name,
      channels: [userId.toString()],
      branchId: branchId!,
    );
    await ProxyService.api
        .create(endPoint: 'category', data: category.toJson());
    _appService.loadCategories();
  }

  void updateCategory({required Category category}) async {
    for (Category category in categories) {
      if (category.focused) {
        Category cat = category;
        cat.focused = !cat.focused;
        cat.active = !cat.active;
        int categoryId = category.id;
        await ProxyService.api.update(
          endPoint: 'category/$categoryId',
          data: cat.toJson(),
        );
      }
    }

    Category cat = category;
    cat.focused = !cat.focused;
    cat.active = !cat.active;

    int categoryId = category.id;
    await ProxyService.api.update(
      endPoint: 'category/$categoryId',
      data: cat.toJson(),
    );
    _appService.loadCategories();
  }

  /// Should save a focused unit given the id to persist to
  /// the Id can be ID of product or variant
  void saveFocusedUnit(
      {required Unit newUnit, String? id, required String type}) async {
    for (Unit unit in units) {
      if (unit.active) {
        unit.active = !unit.active;
        int id = unit.id;
        await ProxyService.api.update(
          endPoint: 'unit/$id',
          data: unit.toJson(),
        );
      }
    }
    Unit unit = newUnit;
    unit.active = !unit.active;
    int id = unit.id;
    await ProxyService.api.update(
      endPoint: 'unit/$id',
      data: unit.toJson(),
    );
    if (type == 'product') {
      final Map data = product.toJson();
      data['unit'] = unit.name;
      ProxyService.api.update(data: data, endPoint: 'product');
      final Product uProduct =
          await ProxyService.api.getProduct(id: product.id);
      productService.setCurrentProduct(product: uProduct);
    }
    if (type == 'variant') {
      // final Map data = product.toJson();
      // data['unit'] = unit.name;
      // ProxyService.api.update(data: data, endPoint: 'variant');
    }
    _appService.loadUnits();
  }

  void updateStock({required int variantId}) async {
    if (_stockValue != null) {
      Stock stock =
          await ProxyService.api.stockByVariantId(variantId: variantId);
      Map data = stock.toJson();
      data['currentStock'] = _stockValue;
      final String stockId = data['id'];

      ProxyService.api.update(data: data, endPoint: 'stock/$stockId');
      productService.variantsProduct(productId: product.id);
    }
    productService.variantsProduct(productId: product.id);
  }

  double? _stockValue;
  double? get stockValue => _stockValue;
  void setStockValue({required double value}) {
    _stockValue = value;
    notifyListeners();
  }

  void deleteVariant({required String id}) {
    ProxyService.api.delete(id: id, endPoint: 'variant');
    createTemporalProduct(); //this will reload the variations remain
  }

  void browsePictureFromGallery({productId}) {
    ProxyService.upload.browsePictureFromGallery(productId: productId);
  }

  void takePicture({productId}) {
    ProxyService.upload.takePicture(productId: productId);
  }

  Future<void> switchColor({required PColor color}) async {
    for (PColor c in colors) {
      if (c.active) {
        final PColor _color =
            await ProxyService.api.getColor(id: c.id, endPoint: 'color');
        final Map mapColor = _color.toJson();
        mapColor['active'] = false;
        final id = mapColor['id'];
        ProxyService.api.update(data: mapColor, endPoint: 'color/$id');
      }
    }

    final PColor _color =
        await ProxyService.api.getColor(id: color.id, endPoint: 'color');

    final Map mapColor = _color.toJson();

    mapColor['active'] = true;
    final id = mapColor['id'];
    ProxyService.api.update(data: mapColor, endPoint: 'color/$id');

    _appService.setCurrentColor(color: color.name!);

    loadColors();
  }

  setUnit({required String unit}) {
    productService.setProductUnit(unit: unit);
  }

  Future<int> addVariant(
      {List<Variation>? variations,
      required double retailPrice,
      required double supplyPrice}) async {
    int result = await ProxyService.api.addVariant(
        data: variations!, retailPrice: retailPrice, supplyPrice: supplyPrice);
    return result;
  }

  void navigateAddVariation({required String productId}) {
    // print(productId);
    ProxyService.nav.navigateTo(
      Routes.variation,
      arguments: AddVariationArguments(
        productId: productId,
      ),
    );
  }

  /// When called should check the related product's variant and set the retail and or supply price
  /// of related stock
  void updateRegularVariant({double? supplyPrice, double? retailPrice}) async {
    if (supplyPrice != null) {
      for (Variation variation in variants!) {
        if (variation.name == "Regular") {
          Stock stock =
              await ProxyService.api.stockByVariantId(variantId: variation.id);
          Map data = stock.toJson();
          data['supplyPrice'] = supplyPrice;
          String id = data['id'];
          ProxyService.api.update(data: data, endPoint: 'stock/$id');
        }
      }
    }

    if (retailPrice != null) {
      for (Variation variation in variants!) {
        if (variation.name == "Regular") {
          Stock stock =
              await ProxyService.api.stockByVariantId(variantId: variation.id);
          Map data = stock.toJson();
          data['retailPrice'] = retailPrice;
          String id = data['id'];
          ProxyService.api.update(data: data, endPoint: 'stock/$id');

          // Stock ustock =
          //     await ProxyService.api.stockByVariantId(variantId: variation.id);

        }
      }
    }
    productService.variantsProduct(productId: product.id);
  }

  Future<bool> addProduct({required Map mproduct}) async {
    if (name != null) {
      mproduct['name'] = name;
      final response =
          await ProxyService.api.update(data: mproduct, endPoint: 'product');
      return response == 200;
    } else {
      return false;
    }
  }

  void deleteProduct({required int productId}) async {
    //get variants->delete
    int branchId = ProxyService.box.read(key: 'branchId');
    List<Variation> variations = await ProxyService.api
        .variants(branchId: branchId, productId: productId);
    for (Variation variation in variations) {
      ProxyService.api.delete(id: variation.id, endPoint: 'variation');
      //get stock->delete
      Stock stock =
          await ProxyService.api.stockByVariantId(variantId: variation.id);
      ProxyService.api.delete(id: stock.id, endPoint: 'stock');
    }
    //then delete the product
    ProxyService.api.delete(id: productId, endPoint: 'product');
    loadProducts(); //refresh list of products
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_appService, productService];
}
