// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $HomeController = BindInject(
  (i) =>
      HomeController(app: i<AppController>(), repository: i<HomeRepository>()),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  final _$indexAtom = Atom(name: '_HomeControllerBase.index');

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  final _$totalToPayAtom = Atom(name: '_HomeControllerBase.totalToPay');

  @override
  double get totalToPay {
    _$totalToPayAtom.reportRead();
    return super.totalToPay;
  }

  @override
  set totalToPay(double value) {
    _$totalToPayAtom.reportWrite(value, super.totalToPay, () {
      super.totalToPay = value;
    });
  }

  final _$carProductsAtom = Atom(name: '_HomeControllerBase.carProducts');

  @override
  List<Product> get carProducts {
    _$carProductsAtom.reportRead();
    return super.carProducts;
  }

  @override
  set carProducts(List<Product> value) {
    _$carProductsAtom.reportWrite(value, super.carProducts, () {
      super.carProducts = value;
    });
  }

  final _$productsAtom = Atom(name: '_HomeControllerBase.products');

  @override
  List<Product> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(List<Product> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  final _$filtedProductsAtom = Atom(name: '_HomeControllerBase.filtedProducts');

  @override
  List<Product> get filtedProducts {
    _$filtedProductsAtom.reportRead();
    return super.filtedProducts;
  }

  @override
  set filtedProducts(List<Product> value) {
    _$filtedProductsAtom.reportWrite(value, super.filtedProducts, () {
      super.filtedProducts = value;
    });
  }

  final _$requestStatusAtom = Atom(name: '_HomeControllerBase.requestStatus');

  @override
  RequestStatus get requestStatus {
    _$requestStatusAtom.reportRead();
    return super.requestStatus;
  }

  @override
  set requestStatus(RequestStatus value) {
    _$requestStatusAtom.reportWrite(value, super.requestStatus, () {
      super.requestStatus = value;
    });
  }

  final _$buttonStatusAtom = Atom(name: '_HomeControllerBase.buttonStatus');

  @override
  RequestStatus get buttonStatus {
    _$buttonStatusAtom.reportRead();
    return super.buttonStatus;
  }

  @override
  set buttonStatus(RequestStatus value) {
    _$buttonStatusAtom.reportWrite(value, super.buttonStatus, () {
      super.buttonStatus = value;
    });
  }

  final _$getProductsAsyncAction =
      AsyncAction('_HomeControllerBase.getProducts');

  @override
  Future<void> getProducts() {
    return _$getProductsAsyncAction.run(() => super.getProducts());
  }

  final _$deleteAllAsyncAction = AsyncAction('_HomeControllerBase.deleteAll');

  @override
  Future<void> deleteAll() {
    return _$deleteAllAsyncAction.run(() => super.deleteAll());
  }

  final _$deleteAllCarProductsAsyncAction =
      AsyncAction('_HomeControllerBase.deleteAllCarProducts');

  @override
  Future<void> deleteAllCarProducts() {
    return _$deleteAllCarProductsAsyncAction
        .run(() => super.deleteAllCarProducts());
  }

  final _$addItemAsyncAction = AsyncAction('_HomeControllerBase.addItem');

  @override
  Future<void> addItem(int i) {
    return _$addItemAsyncAction.run(() => super.addItem(i));
  }

  final _$removeItemAsyncAction = AsyncAction('_HomeControllerBase.removeItem');

  @override
  Future<void> removeItem(int i,
      [bool dispensing = false, bool error = false]) {
    return _$removeItemAsyncAction
        .run(() => super.removeItem(i, dispensing, error));
  }

  final _$endSaleAsyncAction = AsyncAction('_HomeControllerBase.endSale');

  @override
  Future<void> endSale() {
    return _$endSaleAsyncAction.run(() => super.endSale());
  }

  final _$uploadProductsAsyncAction =
      AsyncAction('_HomeControllerBase.uploadProducts');

  @override
  Future<void> uploadProducts() {
    return _$uploadProductsAsyncAction.run(() => super.uploadProducts());
  }

  final _$_HomeControllerBaseActionController =
      ActionController(name: '_HomeControllerBase');

  @override
  void setTotalPrite() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setTotalPrite');
    try {
      return super.setTotalPrite();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSearch(String query) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.onSearch');
    try {
      return super.onSearch(query);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
index: ${index},
totalToPay: ${totalToPay},
carProducts: ${carProducts},
products: ${products},
filtedProducts: ${filtedProducts},
requestStatus: ${requestStatus},
buttonStatus: ${buttonStatus}
    ''';
  }
}
