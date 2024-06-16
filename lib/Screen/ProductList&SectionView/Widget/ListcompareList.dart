import 'dart:async';
import 'package:eshop_multivendor/Screen/ProductList&SectionView/ProductList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Helper/String.dart';
import '../../../Model/Section_Model.dart';
import '../../../Provider/CartProvider.dart';
import '../../../Provider/Favourite/FavoriteProvider.dart';
import '../../../Provider/UserProvider.dart';
import '../../../widgets/desing.dart';
import '../../Language/languageSettings.dart';
import '../../../widgets/networkAvailablity.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/star_rating.dart';
import '../../Dashboard/Dashboard.dart';
import '../../Product Detail/productDetail.dart';
import 'package:collection/src/iterable_extensions.dart';

class ListIteamListWidget extends StatefulWidget {
  List<Product>? productList;
  final int? index;
  int? length;
  Function setState;
  ListIteamListWidget({
    Key? key,
    this.productList,
    this.index,
    required this.setState,
    this.length,
  }) : super(key: key);

  @override
  State<ListIteamListWidget> createState() => _ListIteamListWidgetState();
}

class _ListIteamListWidgetState extends State<ListIteamListWidget> {
  _removeFav(int index, Product model) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        if (mounted) {
          index == -1
              ? model.isFavLoading = true
              : widget.productList![index].isFavLoading = true;
          widget.setState();
        }

        var parameter = {
          USER_ID: context.read<UserProvider>().userId,
          PRODUCT_ID: model.id
        };
        apiBaseHelper.postAPICall(removeFavApi, parameter).then(
          (getdata) {
            bool error = getdata['error'];
            String? msg = getdata['message'];
            if (!error) {
              index == -1
                  ? model.isFav = '0'
                  : widget.productList![index].isFav = '0';
              context
                  .read<FavoriteProvider>()
                  .removeFavItem(model.prVarientList![0].id!);
              setSnackbar(msg!, context);
            } else {
              setSnackbar(msg!, context);
            }

            if (mounted) {
              index == -1
                  ? model.isFavLoading = false
                  : widget.productList![index].isFavLoading = false;
              widget.setState();
            }
          },
          onError: (error) {
            setSnackbar(error.toString(), context);
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg'), context);
      }
    } else {
      if (mounted) {
        isNetworkAvail = false;
        widget.setState();
      }
    }
  }

  removeFromCart(int index) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (context.read<UserProvider>().userId != '') {
        if (mounted) {
          isProgress = true;
          widget.setState();
        }

        int qty;

        qty = (int.parse(controllerText[index].text) -
            int.parse(widget.productList![index].qtyStepSize!));

        if (qty < widget.productList![index].minOrderQuntity!) {
          qty = 0;
        }

        var parameter = {
          PRODUCT_VARIENT_ID: widget.productList![index]
              .prVarientList![0].id,
          USER_ID: context.read<UserProvider>().userId,
          QTY: qty.toString()
        };

        apiBaseHelper.postAPICall(manageCartApi, parameter).then(
          (getdata) {
            bool error = getdata['error'];
            String? msg = getdata['message'];
            if (!error) {
              var data = getdata['data'];

              String? qty = data['total_quantity'];

              context.read<UserProvider>().setCartCount(data['cart_count']);
              widget
                  .productList![index]
                  .prVarientList![0]
                  .cartCount = qty.toString();

              var cart = getdata['cart'];
              List<SectionModel> cartList = (cart as List)
                  .map((cart) => SectionModel.fromCart(cart))
                  .toList();
              context.read<CartProvider>().setCartlist(cartList);
            } else {
              setSnackbar(msg!, context);
            }

            if (mounted) {
              isProgress = false;
              widget.setState();
            }
          },
          onError: (error) {
            setSnackbar(error.toString(), context);
            isProgress = false;
            widget.setState();
          },
        );
      } else {
        isProgress = true;
        widget.setState();

        int qty;

        qty = (int.parse(controllerText[index].text) -
            int.parse(widget.productList![index].qtyStepSize!));

        if (qty < widget.productList![index].minOrderQuntity!) {
          qty = 0;
          db.removeCart(
              widget.productList![index]
                  .prVarientList![0].id!,
              widget.productList![index].id!,
              context);
          context.read<CartProvider>().removeCartItem(widget.productList![index]
              .prVarientList![0].id!);
        } else {
          context.read<CartProvider>().updateCartItem(
              widget.productList![index].id!,
              qty.toString(),
              0,
              widget.productList![index]
                  .prVarientList![0].id!);
          db.updateCart(
            widget.productList![index].id!,
            widget.productList![index]
                .prVarientList![0].id!,
            qty.toString(),
          );
        }
        isProgress = false;
        widget.setState();
      }
    } else {
      if (mounted) {
        isNetworkAvail = false;
        widget.setState();
      }
    }
  }

  _setFav(int index, Product model) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        if (mounted) {
          index == -1
              ? model.isFavLoading = true
              : widget.productList![index].isFavLoading = true;
          widget.setState();
        }

        var parameter = {
          USER_ID: context.read<UserProvider>().userId,
          PRODUCT_ID: model.id
        };
        apiBaseHelper.postAPICall(setFavoriteApi, parameter).then(
          (getdata) {
            bool error = getdata['error'];
            String? msg = getdata['message'];
            if (!error) {
              index == -1
                  ? model.isFav = '1'
                  : widget.productList![index].isFav = '1';

              context.read<FavoriteProvider>().addFavItem(model);
              setSnackbar(msg!, context);
            } else {
              setSnackbar(msg!, context);
            }

            if (mounted) {
              index == -1
                  ? model.isFavLoading = false
                  : widget.productList![index].isFavLoading = false;
              widget.setState();
            }
          },
          onError: (error) {
            setSnackbar(error.toString(), context);
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg'), context);
      }
    } else {
      if (mounted) {
        isNetworkAvail = false;
        widget.setState();
      }
    }
  }

  Future<void> addToCart(int index, String qty, int from) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (context.read<UserProvider>().userId != '') {
        if (mounted) {
          isProgress = true;
          widget.setState();
        }

        if (int.parse(qty) < widget.productList![index].minOrderQuntity!) {
          qty = widget.productList![index].minOrderQuntity.toString();

          setSnackbar("${getTranslated(context, 'MIN_MSG')}$qty", context);
        }

        var parameter = {
          USER_ID: context.read<UserProvider>().userId,
          PRODUCT_VARIENT_ID: widget.productList![index]
              .prVarientList![0].id,
          QTY: qty
        };

        apiBaseHelper.postAPICall(manageCartApi, parameter).then(
          (getdata) {
            bool error = getdata['error'];
            String? msg = getdata['message'];
            if (!error) {
              var data = getdata['data'];
              String? qty = data['total_quantity'];
              context.read<UserProvider>().setCartCount(data['cart_count']);
              widget
                  .productList![index]
                  .prVarientList![0]
                  .cartCount = qty.toString();

              var cart = getdata['cart'];
              List<SectionModel> cartList = (cart as List)
                  .map((cart) => SectionModel.fromCart(cart))
                  .toList();
              context.read<CartProvider>().setCartlist(cartList);
            } else {
              setSnackbar(msg!, context);
            }
            if (mounted) {
              isProgress = false;
              widget.setState();
            }
          },
          onError: (error) {
            setSnackbar(error.toString(), context);
            if (mounted) {
              isProgress = false;
              widget.setState();
            }
          },
        );
      } else {
        isProgress = true;
        widget.setState();

        if (singleSellerOrderSystem) {
          if (CurrentSellerID == '' ||
              CurrentSellerID == widget.productList![index].seller_id) {
            CurrentSellerID = widget.productList![index].seller_id!;
            if (from == 1) {
              List<Product>? prList = [];
              prList.add(widget.productList![index]);
              context.read<CartProvider>().addCartItem(
                    SectionModel(
                      qty: qty,
                      productList: prList,
                      varientId: widget
                          .productList![index]
                          .prVarientList![
                              0]
                          .id!,
                      id: widget.productList![index].id,
                      sellerId: widget.productList![index].seller_id,
                    ),
                  );
              db.insertCart(
                widget.productList![index].id!,
                widget.productList![index]
                    .prVarientList![0].id!,
                qty,
                context,
              );
              setSnackbar(getTranslated(context, 'PRODUCT_ADDED_TO_CART_LBL'),
                  context);
            } else {
              if (int.parse(qty) >
                  int.parse(widget.productList![index].itemsCounter!.last)) {
                setSnackbar(
                    "${getTranslated(context, 'MAXQTY')} ${widget.productList![index].itemsCounter!.last}",
                    context);
              } else {
                context.read<CartProvider>().updateCartItem(
                      widget.productList![index].id!,
                      qty,
                      0,
                      widget
                          .productList![index]
                          .prVarientList![
                              0]
                          .id!,
                    );
                db.updateCart(
                  widget.productList![index].id!,
                  widget
                      .productList![index]
                      .prVarientList![0]
                      .id!,
                  qty,
                );
                setSnackbar(getTranslated(context, 'Cart Update Successfully'),
                    context);
              }
            }
          } else {
            setSnackbar(
                getTranslated(context, 'only Single Seller Product Allow'),
                context);
          }
        } else {
          if (from == 1) {
            List<Product>? prList = [];
            prList.add(widget.productList![index]);
            context.read<CartProvider>().addCartItem(
                  SectionModel(
                    qty: qty,
                    productList: prList,
                    varientId: widget
                        .productList![index]
                        .prVarientList![0]
                        .id!,
                    id: widget.productList![index].id,
                    sellerId: widget.productList![index].seller_id,
                  ),
                );
            db.insertCart(
              widget.productList![index].id!,
              widget.productList![index]
                  .prVarientList![0].id!,
              qty,
              context,
            );
            setSnackbar(
                getTranslated(context, 'PRODUCT_ADDED_TO_CART_LBL'), context);
          } else {
            if (int.parse(qty) >
                int.parse(widget.productList![index].itemsCounter!.last)) {
              setSnackbar(
                  "${getTranslated(context, 'MAXQTY')} ${widget.productList![index].itemsCounter!.last}",
                  context);
            } else {
              context.read<CartProvider>().updateCartItem(
                    widget.productList![index].id!,
                    qty,
                    0,
                    widget
                        .productList![index]
                        .prVarientList![0]
                        .id!,
                  );
              db.updateCart(
                widget.productList![index].id!,
                widget.productList![index]
                    .prVarientList![0].id!,
                qty,
              );
              setSnackbar(
                  getTranslated(context, 'Cart Update Successfully'), context);
            }
          }
        }
        isProgress = false;
        widget.setState();
      }
    } else {
      if (mounted) {
        isNetworkAvail = false;
        widget.setState();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index! < widget.productList!.length) {
      Product model = widget.productList![widget.index!];

      totalProduct = model.total;

      if (controllerText.length < widget.index! + 1) {
        controllerText.add(TextEditingController());
      }

      List att = [], val = [];
      if (model.prVarientList![0].attr_name != null) {
        att = model.prVarientList![0].attr_name!.split(',');
        val = model.prVarientList![0].varient_value!.split(',');
      }

      double price =
          double.parse(model.prVarientList![0].disPrice!);
      if (price == 0) {
        price = double.parse(model.prVarientList![0].price!);
      }

      double off = 0;
      if (model.prVarientList![0].disPrice! != '0') {
        off = (double.parse(model.prVarientList![0].price!) -
                double.parse(model.prVarientList![0].disPrice!))
            .toDouble();
        off = off *
            100 /
            double.parse(model.prVarientList![0].price!);
      }
      return Padding(
          padding: const EdgeInsetsDirectional.only(
              start: 10.0, end: 10.0, top: 5.0),
          child: Consumer<CartProvider>(
            builder: (context, data, _) {
              final tempId = data.cartList.firstWhereOrNull((cp) =>
                  cp.id == model.id &&
                  cp.varientId == model.prVarientList![0].id!);

              if (tempId != null) {
                controllerText[widget.index!].text = tempId.qty!;
              } else {
                controllerText[widget.index!].text = '0';
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    elevation: 0,
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(circularBorderRadius10),
                      child: Stack(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Hero(
                                tag:
                                    '$heroTagUniqueString${widget.index}${model.id}',
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft:
                                        Radius.circular(circularBorderRadius4),
                                    bottomLeft:
                                        Radius.circular(circularBorderRadius4),
                                  ),
                                  child: Stack(
                                    children: [
                                      DesignConfiguration.getCacheNotworkImage(
                                        boxFit: BoxFit.fitHeight,
                                        context: context,
                                        heightvalue: 125.0,
                                        widthvalue: 110.0,
                                        imageurlString: model.image!,
                                        placeHolderSize: 125,
                                      ),
                                      Positioned.fill(
                                        child: model.prVarientList![0].availability == '0'
                                            ? Container(
                                                height: 55,
                                                color: colors.white70,
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Center(
                                                  child: Text(
                                                    getTranslated(context,
                                                        'OUT_OF_STOCK_LBL'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color: colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ),
                                      off != 0
                                          ? Container(
                                              decoration: const BoxDecoration(
                                                color: colors.red,
                                              ),
                                              margin: const EdgeInsets.all(5),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  '${off.round().toStringAsFixed(2)}%',
                                                  style: const TextStyle(
                                                    color: colors.whiteTemp,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: textFontSize9,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                          top: 2.0,
                                          start: 15.0,
                                        ),
                                        child: Text(
                                          widget.productList![widget.index!]
                                              .name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .fontColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: textFontSize12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                          start: 15.0,
                                          top: 4.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              ' ${DesignConfiguration.getPriceFormat(context, price)!}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .blue,
                                                fontSize: textFontSize14,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                  start: 10.0,
                                                  top: 5,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      double.parse(widget
                                                                  .productList![
                                                                      widget
                                                                          .index!]
                                                                  .prVarientList![
                                                                      0]
                                                                  .disPrice!) !=
                                                              0
                                                          ? '${DesignConfiguration.getPriceFormat(context, double.parse(widget.productList![widget.index!].prVarientList![0].price!))}'
                                                          : '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .lightBlack,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            decorationColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .gray,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decorationThickness:
                                                                2,
                                                            letterSpacing: 0,
                                                            fontSize:
                                                                textFontSize10,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                top: 5.0, start: 15.0),
                                        child: StarRating(
                                          noOfRatings: widget
                                              .productList![widget.index!]
                                              .noOfRating!,
                                          totalRating: widget
                                              .productList![widget.index!]
                                              .rating!,
                                          needToShowNoOfRatings: true,
                                        ),
                                      ),
                                      controllerText[widget.index!].text != '0'
                                          ? Row(
                                              children: [
                                                model.prVarientList![0].availability == '0'
                                                    ? const SizedBox()
                                                    : cartBtnList
                                                        ? Row(
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  InkWell(
                                                                    child: Card(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          circularBorderRadius50,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          const Padding(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                          8.0,
                                                                        ),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .remove,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: () {
                                                                      if (isProgress ==
                                                                              false &&
                                                                          (int.parse(controllerText[widget.index!].text) >
                                                                              0)) {
                                                                        removeFromCart(
                                                                            widget.index!);
                                                                      }
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    width: 37,
                                                                    height: 20,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        TextField(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          readOnly:
                                                                              true,
                                                                          style: TextStyle(
                                                                              fontSize: textFontSize12,
                                                                              color: Theme.of(context).colorScheme.fontColor),
                                                                          controller:
                                                                              controllerText[widget.index!],
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                InputBorder.none,
                                                                          ),
                                                                        ),
                                                                        PopupMenuButton<
                                                                            String>(
                                                                          tooltip:
                                                                              '',
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.arrow_drop_down,
                                                                            size:
                                                                                1,
                                                                          ),
                                                                          onSelected:
                                                                              (String value) {
                                                                            if (isProgress ==
                                                                                false) {
                                                                              addToCart(widget.index!, value, 2);
                                                                            }
                                                                          },
                                                                          itemBuilder:
                                                                              (BuildContext context) {
                                                                            return model.itemsCounter!.map<PopupMenuItem<String>>(
                                                                              (String value) {
                                                                                return PopupMenuItem(value: value, child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.fontColor)));
                                                                              },
                                                                            ).toList();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    child: Card(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(circularBorderRadius50),
                                                                      ),
                                                                      child:
                                                                          const Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .add,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: () {
                                                                      if (isProgress ==
                                                                          false) {
                                                                        addToCart(
                                                                          widget
                                                                              .index!,
                                                                          (int.parse(controllerText[widget.index!].text) + int.parse(model.qtyStepSize!))
                                                                              .toString(),
                                                                          2,
                                                                        );
                                                                      }
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),
                                              ],
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        Product model = widget.productList![widget.index!];
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ProductDetail(
                              model: model,
                              index: widget.index,
                              secPos: 0,
                              list: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (cartBtnList && model.prVarientList![0].availability != '0')
                    controllerText[widget.index!].text == '0'
                        ? Positioned.directional(
                            textDirection: Directionality.of(context),
                            bottom: 4,
                            end: 4,
                            child: InkWell(
                              onTap: () {
                                if (isProgress == false) {
                                  addToCart(
                                    widget.index!,
                                    (int.parse(controllerText[widget.index!]
                                                .text) +
                                            int.parse(model.qtyStepSize!))
                                        .toString(),
                                    1,
                                  );
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: 4,
                    end: 4,
                    child: model.isFavLoading!
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: colors.primary,
                                strokeWidth: 0.7,
                              ),
                            ),
                          )
                        : Selector<FavoriteProvider, List<String?>>(
                            builder: (context, data, child) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    !data.contains(model.id)
                                        ? Icons.favorite_border
                                        : Icons.favorite,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  if (context.read<UserProvider>().userId !=
                                      '') {
                                    !data.contains(model.id)
                                        ? _setFav(-1, model)
                                        : _removeFav(-1, model);
                                  } else {
                                    if (!data.contains(model.id)) {
                                      model.isFavLoading = true;
                                      model.isFav = '1';
                                      context
                                          .read<FavoriteProvider>()
                                          .addFavItem(model);
                                      db.addAndRemoveFav(model.id!, true);
                                      model.isFavLoading = false;
                                      setSnackbar(
                                          getTranslated(
                                              context, 'Added to favorite'),
                                          context);
                                    } else {
                                      model.isFavLoading = true;
                                      model.isFav = '0';
                                      context
                                          .read<FavoriteProvider>()
                                          .removeFavItem(
                                              model.prVarientList![0].id!);
                                      db.addAndRemoveFav(model.id!, false);
                                      model.isFavLoading = false;
                                      setSnackbar(
                                          getTranslated(context,
                                              'Removed from favorite'),
                                          context);
                                    }
                                    widget.setState();
                                  }
                                },
                              );
                            },
                            selector: (_, provider) => provider.favIdList,
                          ),
                  ),
                ],
              );
            },
          ));
    } else {
      return const SizedBox();
    }
  }
}
