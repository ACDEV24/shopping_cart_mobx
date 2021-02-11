import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shopping_cart_mobx/app/models/product.dart';
import 'package:shopping_cart_mobx/app/utils/contants.dart';
import 'package:shopping_cart_mobx/app/utils/methods.dart';
import 'package:sweetalert/sweetalert.dart';

import '../../app_controller.dart';
import 'home_repository.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {

  final AppController app;
  final HomeRepository repository;
  _HomeControllerBase({this.app, this.repository}) {
    this.getProducts();
  }

  BuildContext context;
  String cartID = '';

  @observable
  int index = 0;

  @observable
  double totalToPay = 0.0;

  @observable
  List<Product> carProducts = [];

  @observable
  List<Product> products = [];

  @observable
  List<Product> filtedProducts = [];

  @observable
  RequestStatus requestStatus;

  @observable
  RequestStatus buttonStatus;

  @action
  Future<void> getProducts() async {

    this.requestStatus = RequestStatus.loading;

    if(this.cartID.isEmpty) {
      final Map<String, dynamic> response = await this.repository.createCart();
      if(response['ok']) {
        this.cartID = response['id'];
      }
    }

    final Map<String, dynamic> response = await this.repository.getProducts();

    if(!response['ok']) {
      this.requestStatus = RequestStatus.error;
      return onRequestError(response, this.getProducts);
    }

    this.products = response['products'];
    this.filtedProducts = response['products'];

    this.requestStatus = RequestStatus.done;

    if(this.carProducts == null) {
      this.carProducts = [];
      return;
    }

    this.totalToPay = 0.0;

    this.carProducts.forEach((item) {
      this.totalToPay += item.price * item.carQuantity;
    });
  }

  @action
  Future<void> deleteAll() async {
    SweetAlert.show(
      this.context,
      title: '¡Advertencia!',
      subtitle: '¿Deseas borrar todoslos productos de tu carrito?',
      style: SweetAlertStyle.confirm,
      cancelButtonText: 'Cancelar',
      showCancelButton: true,
      confirmButtonText: 'Borrar',
      cancelButtonColor: Colors.red,
      onPress: (close) {
        if(!close) return true;
        this.deleteAllCarProducts();
        return true;
      }
    );
  }

  @action
  Future<void> deleteAllCarProducts() async {
    this.carProducts.clear();
    this.setTotalPrite();
    this.carProducts = this.carProducts;
    this.filtedProducts = this.filtedProducts.map((product) {
      
      product = product.copyWith(
        carQuantity: 0
      );

      return product;
    }).toList();
  }

  @action
  void setTotalPrite() {

    double price = 0.0;

    this.carProducts.forEach((item) {
      price += (item.price * item.carQuantity) / 1;
    });

    this.totalToPay = price / 1;
  }

  @action
  void onSearch(String query) {
    if(query.length == 0) this.filtedProducts = this.products;
    this.filtedProducts = this.filtedProducts.where(
      (p) => p.name.toLowerCase().contains('$query')
    ).toList();
  }

  @action
  Future<void> addItem(int i) async {

    if(this.filtedProducts[i].carQuantity == this.filtedProducts[i].stock) return;

    final int cartIndex = this.carProducts.indexWhere((p) {
      return p.id == this.filtedProducts[i].id;
    });

    if(cartIndex != -1) {

      this.filtedProducts[i] = this.filtedProducts[i].copyWith(
        carQuantity: this.filtedProducts[i].carQuantity + 1
      );

      this.carProducts[cartIndex] = this.filtedProducts[i];

    } else {

      this.filtedProducts[i] = this.filtedProducts[i].copyWith(
        carQuantity: this.filtedProducts[i].carQuantity + 1
      );

      this.carProducts.add(this.filtedProducts[i]);
    }

    final Product product = await this.updateProductOnDB(this.filtedProducts[i]);

    this.filtedProducts[i] = product;
    
    if(cartIndex > -1) {
      this.carProducts[cartIndex] = product;
    } else {
      final int length = this.carProducts.length;
      this.carProducts[length - 1] = product;
    }

    this.filtedProducts = this.filtedProducts;
    this.setTotalPrite();
  }

  @action
  Future<void> removeItem(int i, [bool dispensing = false, bool error = false]) async {

    if(this.filtedProducts[i].carQuantity >= 1) {

      final int index = this.carProducts.indexWhere((p) => p.id == this.filtedProducts[i].id);

      this.filtedProducts[i] = this.filtedProducts[i].copyWith(
        carQuantity: this.filtedProducts[i].carQuantity - 1
      );

      this.carProducts.removeAt(index);
      this.carProducts.add(this.filtedProducts[i]);
    }

    if(this.filtedProducts[i].carQuantity == 0) {
      this.carProducts.remove(this.filtedProducts[i]);
    }

    await this.updateProductOnDB(this.filtedProducts[i]);
    
    this.carProducts = this.carProducts;
    this.filtedProducts = this.filtedProducts;

    this.setTotalPrite();
  }

  @action
  Future<void> endSale() async {

    SweetAlert.show(
      this.context,
      title: '\n¿Desea realizar esta compra?',
      subtitle: '',
      style: SweetAlertStyle.confirm,
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      confirmButtonText: 'Confirmar',
      onPress: (bool isConfirm) {
        
      if (isConfirm) {
        this.uploadProducts();
        return true;
      }
      
      return true;
    });
  }

  @action
  Future<void> uploadProducts() async {

    this.requestStatus = RequestStatus.loading;

    for(Product p in this.carProducts) {
      await this.repository.updateProcuct(
        p.id,
        {
          'active': p.active,
          'name': p.name,
          'picture': p.picture,
          'price': p.price,
          'stock': p.stock - p.carQuantity,
        }
      );
    }

    await this.repository.endSale(this.cartID);
    await this.getProducts();
    this.setTotalPrite();

    SweetAlert.show(
      context,
      style: SweetAlertStyle.success,
      title: 'Success'
    );

    this.carProducts = [];
    this.index = 0;
    this.totalToPay = 0.0;

    this.requestStatus = RequestStatus.done;
  }

  Future<Product> updateProductOnDB(Product product) async {

    if(product.carsID.length == 0) {

      final Map<String, dynamic> response = await this.repository.addProcuctCart({
        'cart_id': this.cartID,
        'product_id': product.id,
        'quantity': product.carQuantity
      });

      product = product.copyWith(
        carsID: response['id']
      );
      
    } else {
      await this.repository.updateProcuctCart(
        product.carsID,
        {
          'cart_id': this.cartID,
          'product_id': product.id,
          'quantity': product.carQuantity
        }
      );
    }

    return product;
  }
}
