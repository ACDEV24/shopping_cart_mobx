import 'package:shopping_cart_mobx/app/models/product.dart';
import 'package:shopping_cart_mobx/app/utils/contants.dart';
import 'package:shopping_cart_mobx/app/utils/methods.dart';
import 'package:shopping_cart_mobx/app/utils/screen_size.dart';
import 'package:shopping_cart_mobx/app/widgets/custom_circular_progressIndicator.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart_mobx/app/modules/home/home_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sort_price/sort_price.dart';

class ShoppingCarPage extends StatelessWidget {

  final HomeController controller;
  const ShoppingCarPage(this.controller);

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      _ProductsWidget(this.controller),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 100.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeInLeft(
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18.0
                        ),
                      ),
                    ),
                    FadeInRight(
                      child: Observer(
                        builder: (_) => Text(
                          '\$${sortPrice(this.controller.totalToPay, false)}',
                          style: TextStyle(
                            color: const Color(0xff3ca78b),
                            fontSize: 18.0
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Observer(
                builder: (_) => FadeInUp(
                  child: MaterialButton(
                    color: this.controller.app.darkBlueColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.width * 0.35,
                      vertical: 10.0
                    ),
                    disabledColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: (this.controller.buttonStatus == RequestStatus.loading) ? 
                    CustomCircularProgressIndicator(
                      size: 20.0,
                    ) : Text(
                      'Comprar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0
                      ),
                    ),
                    onPressed: (this.controller.carProducts.length == 0)
                      ? null : this.controller.endSale,
                  ),
                )
              )
            ],
          ),
        ),
      )
    ],
  );
}

class _ProductsWidget extends StatelessWidget {

  final HomeController controller;
  const _ProductsWidget(this.controller);

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {

      if(
        this.controller.carProducts.length == 0 && 
        this.controller.filtedProducts.where((p) => p.carQuantity > 0).toList().length == 0
      ) return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FadeIn(
          child: Center(
            child: Text(
              'Actualmente no tienes productos en el carrito',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.center
            ),
          ),
        ),
      );
      
      return Observer(
        builder: (_) => ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            bottom: 100.0
          ),
          itemCount: this.controller.filtedProducts.length,
          itemBuilder: (_, i) =>  _ItemWidget(
            this.controller,
            this.controller.filtedProducts[i],
            i
          )
        ),
      );
    },
  );
}

class _ItemWidget extends StatelessWidget {

  final HomeController controller;
  final Product item;
  final int i;
  const _ItemWidget(this.controller, this.item, this.i);

  @override
  Widget build(BuildContext context) => (this.item.carQuantity == 0) ? Container() : FadeInDown(
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _ImageWidget(
                controller: this.controller,
                product: this.item
              ),
              SizedBox(width: 15.0),
              _ProductDetail(
                item: this.item,
                controller: this.controller,
                i: this.i
              )
            ],
          ),
          Text(
            '\$${sortPrice(this.item.price, false)}',
            style: TextStyle(
              color: const Color(0xff3ca78b),
              fontSize: 15.0
            )
          )
        ],
      ),
    ),
  );
}

class _ProductDetail extends StatelessWidget {

  final Product item;
  final HomeController controller;
  final int i;

  const _ProductDetail({
    this.item,
    this.controller,
    this.i,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 100.0,
        child: Text(
          '${this.item.name}',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      SizedBox(height: 15.0),
      Container(
        width: 100.0,
        height: 30.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black
          ),
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: SizedBox(
                width: 20.0,
                child: Icon(
                  Icons.remove,
                  size: 20.0,
                  color: Colors.black
                ),
              ),
              onTap: () => this.controller.removeItem(this.i),
            ),
            Text(
              '${this.item.carQuantity}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0
              ),
            ),
            InkWell(
              child: SizedBox(
                width: 20.0,
                child: Icon(
                  Icons.add,
                  size: 20.0,
                  color: Colors.black
                ),
              ),
              onTap: () => this.controller.addItem(this.i),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ImageWidget extends StatelessWidget {

  final HomeController controller;
  final Product product;

  const _ImageWidget({
    @required this.controller,
    this.product,
  });

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: getColor(this.product.picture),
    builder: (_, snapshot) => Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: snapshot.data,
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: CachedNetworkImage(
        imageUrl: this.product.picture,
        placeholder: (_, url) => Image(
          image: AssetImage('assets/loading.gif'), 
          height: 150.0,
          width: 150.0,
          fit: BoxFit.cover
        ),
        errorWidget: (_, __, ___) => Icon(Icons.error),
        height: 100.0,
        width: 100.0
      ),
    )
  );
}
