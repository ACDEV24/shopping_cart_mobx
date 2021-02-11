import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shopping_cart_mobx/app/utils/methods.dart';
import 'package:sort_price/sort_price.dart';
import 'package:shopping_cart_mobx/app/utils/contants.dart';
import 'package:shopping_cart_mobx/app/utils/screen_size.dart';
import 'package:shopping_cart_mobx/app/widgets/custom_circular_progressIndicator.dart';

import 'home_controller.dart';
import 'pages/shoppingcart.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {

  @override
  void initState() {
    this.controller.context = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) => Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping cart'
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: (this.controller.index != 0) ? null : _BottomAppbar(this.controller),
        leading: Observer(
          builder: (_) => IconButton(
            icon: Icon(
              (this.controller.index == 0) ? Icons.shopping_cart : Icons.arrow_back,
              color: Colors.white,
            ),
            splashRadius: 20.0,
            onPressed: () {

              if(this.controller.index > 0) this.controller.index--;
              else this.controller.index++;

            },
          )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: (this.controller.index == 1) ? 
              IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: this.controller.deleteAll,
              ) : Text(
                '\$${(this.controller.totalToPay == 0) ? '0.0' : sortPrice(this.controller.totalToPay, false)}',
                style: TextStyle(
                  fontSize: 16.0
                )
              ),
            ),
          )
        ],
      ),
      body: _BodyWidget(this.controller)
    )
  );
}

class _BottomAppbar extends StatelessWidget with PreferredSizeWidget {

  final HomeController controller;
  const _BottomAppbar(this.controller);

  @override
  Widget build(BuildContext context) => PreferredSize(
    child: Container(
      padding: const EdgeInsets.all(
        10.0
      ),
      child: Card(
        child: Container(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Buscar producto',
              icon: IconButton(
                icon: Icon(
                  Icons.search
                ),
                onPressed: () {}
              ),
            ),
            onChanged: this.controller.onSearch,
          ),
        ),
      ),
    ),
    preferredSize: Size.fromHeight(80.0),
  );

  @override  
  Size get preferredSize => Size.fromHeight(80.0);
}

class _BodyWidget extends StatelessWidget {

  final HomeController controller;
  const _BodyWidget(this.controller);

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {

      if(this.controller.requestStatus == RequestStatus.loading) return Center(
        child: CustomCircularProgressIndicator(
          color: this.controller.app.darkBlueColor,
        )
      );

      if(this.controller.index == 1) return ShoppingCarPage(this.controller);

      if(this.controller.requestStatus == RequestStatus.error) return _RefreshButton(this.controller);

      if(this.controller.filtedProducts.length == 0) return Center(
        child: ElasticIn(
          child: Text(
            'Lo sentimos\nNo se encuentra el producto que buscas',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );

      return Stack(
        children: [
          (this.controller.requestStatus == RequestStatus.loading) ? Center(
            child: CustomCircularProgressIndicator(
              color: this.controller.app.darkBlueColor,
            ),
          ) : (this.controller.requestStatus == RequestStatus.error) ? Center(
            child: MaterialButton(
              child: Text('Recargar'),
              onPressed: () => this.controller.getProducts(),
            ),
          ) : RefreshIndicator(
            onRefresh: () => this.controller.getProducts(),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: ScreenSize.height * 0.09
              ),
              itemCount: this.controller.filtedProducts.length,
              itemBuilder: (_, i) => _ItemWidget(
                this.controller,
                i
              ),
            ),
          ),
        ],
      );
    }
  );
}

class _RefreshButton extends StatelessWidget {

  final HomeController controller;
  const _RefreshButton(this.controller);

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Lo sentimos\nNo pudimos encontrar los productos',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.0
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.0),
        Container(
          width: 140.0,
          child: MaterialButton(
            splashColor: this.controller.app.skyBlueColor,
            color: this.controller.app.darkBlueColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                SizedBox(width: 15.0),
                Text(
                  'Reintentar',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ],
            ),
            onPressed: () {}
          ),
        ),
      ],
    ),
  );
}

class _ItemWidget extends StatelessWidget {

  final HomeController controller;
  final int i;
  const _ItemWidget(this.controller, this.i);

  @override
  FutureBuilder<Color> build(BuildContext context) => FutureBuilder<Color>(
    future: getColor(this.controller.filtedProducts[this.i].picture),
    builder: (_, snapshot) => ElasticIn(
      duration: const Duration(milliseconds: 600),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 0.0),
              blurRadius: 15.0,
              spreadRadius: 1.5
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _MiddleItem(this.controller, snapshot.data, this.i),
            _AddToCarWidget(this.controller, this.i)
          ],
        ),
      ),
    ),
  );
}

class _MiddleItem extends StatelessWidget {

  final HomeController controller;
  final Color color;
  final int i;
  const _MiddleItem(this.controller, this.color, this.i);

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _ImageWidget(
        color: this.color,
        controller: this.controller,
        i: this.i
      ),
      Container(
        width: 125.0,
        padding: const EdgeInsets.only(
          left: 10.0,
          top: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${this.controller.filtedProducts[this.i].name}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.0
              ),
            ),
            SizedBox(height: 38.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Precio: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0
                    )
                  ),
                  TextSpan(
                    text: '\$${sortPrice(this.controller.filtedProducts[this.i].price, false)}',
                    style: TextStyle(
                      color: const Color(0xff3ca78b),
                      fontSize: 15.0
                    )
                  ),
                ]
              ),
            ),
            SizedBox(
              height: 38.0
            ),
            Observer(
              builder: (_) {

                final int totalPrice = this.controller.filtedProducts[this.i].totalPrice;

                if(totalPrice == 0) return FadeOut();

                return FadeIn(
                  duration: const Duration(milliseconds: 200),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Total: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0
                          )
                        ),
                        TextSpan(
                          text: '\$${sortPrice(totalPrice, false)}',
                          style: TextStyle(
                            color: const Color(0xff3ca78b),
                            fontSize: 16.0
                          )
                        ),
                      ]
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    ],
  );
}

class _ImageWidget extends StatelessWidget {

  final Color color;
  final HomeController controller;
  final int i;

  const _ImageWidget({
    @required this.color,
    @required this.controller,
    @required this.i,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      color: this.color,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        topLeft: Radius.circular(15.0),
      )
    ),
    child: CachedNetworkImage(
      imageUrl: this.controller.filtedProducts[this.i].picture,
      placeholder: (_, url) => Image(
        image: AssetImage('assets/loading.gif'), 
        height: 150.0,
        fit: BoxFit.cover
      ),
      errorWidget: (_, __, ___) => Icon(Icons.error),
      height: 150.0,
      width: ScreenSize.width * 0.26
    ),
  );
}

class _AddToCarWidget extends StatelessWidget {

  final HomeController controller;
  final int i;

  const _AddToCarWidget(
    this.controller,
    this.i
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      right: 8.0,
      bottom: 8.0
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 5.0),
        InkWell(
          splashColor: Colors.grey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                )
              ],
              shape: BoxShape.circle
            ),
            child: Icon(
              Icons.add,
              size: 30.0,
              color: const Color(0xff3ca78b)
            ),
          ),
          onTap: () => this.controller.addItem(this.i)
        ),
        SizedBox(height: 20.0),
        Container(
          height: 45.0,
          width: 25.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
              )
            ]
          ),
          child: Center(
            child: Text(
              '${this.controller.filtedProducts[this.i].carQuantity}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                )
              ],
              shape: BoxShape.circle
            ),
            child: Icon(
              Icons.remove,
              size: 30.0,
              color: Colors.red
            ),
          ),
          onTap: () => this.controller.removeItem(i),
        ),
      ],
    ),
  );
}