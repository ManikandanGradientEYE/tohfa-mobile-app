import 'package:demo/export.dart';

import '../../report/widget/report_screen_appbar.dart';
import '../model/food_menu_model.dart';

// ignore: must_be_immutable
class MealOrderScreen extends StatelessWidget {
  final String id;

  MealOrderScreen({super.key, required this.id});
  String _selectedDay =
      DateTime.now().hour >= 12 ? "Tomorrow" : "Today";
  static Widget builder(BuildContext context, String id) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit()..activeFoodMenu(id),
      child: MealOrderScreen(
        id: id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reportScreenAppbar("Order Meals"),
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) async {
            final bloc = context.read<HomeCubit>();
            if (bloc.orderToken != null) {
              await _showNormalDialog(context, bloc.orderToken!);
              bloc.orderToken = null;
              NavigatorService.goBack();
            }
          },
          builder: (context, state) {
            final bloc = context.read<HomeCubit>();
            if (state is HomeErrorState) {
              return _buildErrorState(context, state);
            } else if (state is HomeSuccessState || state is HomeLoadingState) {
              final food = (bloc.activeFoodsModel?.data ?? []).toList();
              return Stack(
                children: [
                  _foodMenuBuilder(food, context , _selectedDay == "Today" ? true:false),
                  Visibility(
                    visible: state is HomeLoadingState,
                    child: Container(
                      color: AppColors.black.withValues(alpha: .07),
                      child: CustomLoading(),
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: CustomLoading());
            }
          },
        ),
      ),
    );
  }

  ///Single Food Item
  Widget _singleFoodItemBuilder(FoodItem food ,) {
    final now = DateTime.now();
    final isAfterNoon = now.hour >= 12;
   
    return StatefulBuilder(builder: (context, setState) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(getSize(8)),
        child: Container(
          height: getSize(100),
          color: AppColors.whiteText,
          child: Row(
            children: [
              /// Image
              Expanded(
                child: Container(
                  height: double.infinity,
                  color: AppColors.white,
                  child: CustomImageView(
                    url: food.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              /// Name + Cart Button
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if(!isAfterNoon)
                        Radio<String>(
                          value: "Today",
                          groupValue: _selectedDay,
                          onChanged: isAfterNoon
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedDay = value;
                                    });
                                  }
                                },
                          activeColor: Colors.black,
                        ),
                        if(!isAfterNoon)
                        const Text("Today"),
                        Radio<String>(
                          value: "Tomorrow",
                          groupValue: _selectedDay,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedDay = value;
                              });
                            }
                          },
                          activeColor: Colors.black,
                        ),
                        const Text("Tomorrow"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// Food name
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                maxLines: 3,
                                text: food.name ?? "N/A",
                                style: CustomTextStyle.headingText.copyWith(
                                  color: AppColors.primaryColor,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: getSize(15),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// Cart Actions
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BlocBuilder<HomeCubit, HomeState>(
                                builder: (context, state) {
                                  final cubit = context.read<HomeCubit>();
                                  final isInCart = cubit.isItemInCart(food.id);

                                  return isInCart
                                      ? _buildQuantityControls(context, food)
                                      : _buildAddToCartButton(context, food);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

    Widget _foodMenuBuilder(
    List<FoodItem> food,
    BuildContext context,
    bool isToday,
  ) {
    final bloc = context.read<HomeCubit>();

    List<FoodItem> newFoodList = food
        .where(
          (element) => element.menucategoryname == "Meals",
        )
        .toList();

  
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: getPadding(all: 10),
            child:
                // bloc.showCart
                //     ? _foodCartView(context)
                //     :
                Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Check out Meals",
                            style: CustomTextStyle.headingText.copyWith(
                                color: AppColors.primaryColor,
                                fontSize: getSize(16),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),

                    ///Show Cart Button
                    // Visibility(
                    //   visible: bloc.cartItems.isNotEmpty,
                    //   child: InkWell(
                    //     onTap: () {
                    //       bloc.toggleCartView(true);
                    //     },
                    //     child: Container(
                    //       padding: getPadding(left: 10, right: 10),
                    //       decoration: BoxDecoration(
                    //         color: AppColors.primaryColor,
                    //         borderRadius: BorderRadius.circular(getSize(8)),
                    //       ),
                    //       child: CustomText(
                    //         text: "Show Cart",
                    //         style: CustomTextStyle.headingText.copyWith(
                    //             color: AppColors.whiteText,
                    //             fontSize: getSize(14),
                    //             fontWeight: FontWeight.w500),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                getSizeBox(height: 10),
                ListView.separated(
                  primary: false,

                  // scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => getSizeBox(height: 10),
                  itemBuilder: (context, index) =>
                      _singleFoodItemBuilder(newFoodList[index]),
                  shrinkWrap: true,
                  itemCount: newFoodList.length,
                ),
                getSizeBox(height: 20),
              ],
            ),
          ),
        ),

        ///Show Cart Button
        Visibility(
          visible: bloc.cartItems.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(8)),
                  ),
                  padding: getPadding(top: 12, bottom: 12),
                ),
                onPressed: () {
                  ///Check cart is not empty
                  if (bloc.cartItems.isEmpty) {
                    HapticFeedback.vibrate();
                    showToast("Please add food items to cart");
                    return;
                  }

                  ///Place order
                  bloc.orderFood(id , isToday);
                },
                child: CustomText(
                  text: "Order",
                  style: CustomTextStyle.normalText.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _showNormalDialog(BuildContext context, String token) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Start a timer to close the dialog after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });
        return Dialog(
          backgroundColor: AppColors.whiteText,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getSizeBox(height: 40),
              CustomImageView(
                imagePath: ImageConstants.orderCompleted,
                height: getSize(100),
                width: getSize(100),
              ),
              getSizeBox(height: 20),
              CustomText(
                textAlign: TextAlign.center,
                text: "Your  order has been placed\n successfully!",
                style: CustomTextStyle.normalText.copyWith(
                    color: Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w500,
                    fontSize: getSize(15)),
              ),
              getSizeBox(height: 10),
              CustomText(
                textAlign: TextAlign.center,
                text: "with Token No: “$token”",
                style: CustomTextStyle.normalText.copyWith(
                    color: Color(0xFF646464),
                    fontWeight: FontWeight.w500,
                    fontSize: getSize(14)),
              ),
              getSizeBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, HomeErrorState state) {
    return RefreshIndicator(
      onRefresh: () {
        context.read<HomeCubit>().activeFoodMenu(id);
        return Future.delayed(Duration.zero);
      },
      backgroundColor: AppColors.white,
      color: AppColors.primaryColor,
      child: NoDataFoundView(message: state.error),
    );
  }



  // Widget _foodCartView(BuildContext context) {
  //   final bloc = context.read<HomeCubit>();
  //   return Column(
  //     spacing: getSize(10),
  //     children: [
  //       // Cart header
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           CustomText(
  //             text: "Your Cart",
  //             style: CustomTextStyle.headingText.copyWith(
  //               fontSize: getSize(18),
  //               fontWeight: FontWeight.bold,
  //               color: AppColors.primaryColor,
  //             ),
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.close, color: AppColors.primaryColor),
  //             onPressed: () {
  //               bloc.toggleCartView(false);
  //             },
  //           ),
  //         ],
  //       ),

  //       Container(
  //         // m: getPadding(all: 16),

  //         decoration: BoxDecoration(
  //           color: AppColors.white,
  //           border: Border.all(
  //               color: AppColors.primaryColor.withValues(alpha: .84)),
  //         ),
  //         child: ListView.separated(
  //           primary: false,
  //           shrinkWrap: true,
  //           padding: getPadding(all: 5),
  //           itemCount: bloc.cartItems.length,
  //           separatorBuilder: (_, __) => getSizeBox(height: 5),
  //           itemBuilder: (context, index) {
  //             final item = bloc.cartItems[index];

  //             ///get food item from food list
  //             final food = (bloc.activeFoodsModel?.data ?? []).firstWhere(
  //               (element) => element.id.toString() == item.id,
  //               orElse: () => FoodItem(),
  //             );
  //             return _singleFoodItemBuilder(food);
  //           },
  //         ),
  //       ),

  //       if (bloc.cartItems.isNotEmpty) ...[
  //         Divider(height: 1),
  //         // Padding(
  //         //   padding: getPadding(all: 16),
  //         //   child: Column(
  //         //     children: [
  //         //       Row(
  //         //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //         children: [
  //         //           CustomText(
  //         //             text: "Subtotal",
  //         //             style: CustomTextStyle.normalText,
  //         //           ),
  //         //           CustomText(
  //         //             text: "\$${bloc.cartSubtotal.toStringAsFixed(2)}",
  //         //             style: CustomTextStyle.normalText.copyWith(
  //         //               fontWeight: FontWeight.bold,
  //         //             ),
  //         //           ),
  //         //         ],
  //         //       ),
  //         //       getSizeBox(height: 8),
  //         //       Row(
  //         //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //         children: [
  //         //           CustomText(
  //         //             text: "Tax",
  //         //             style: CustomTextStyle.normalText,
  //         //           ),
  //         //           CustomText(
  //         //             text: "\$${bloc.cartTax.toStringAsFixed(2)}",
  //         //             style: CustomTextStyle.normalText.copyWith(
  //         //               fontWeight: FontWeight.bold,
  //         //             ),
  //         //           ),
  //         //         ],
  //         //       ),
  //         //       getSizeBox(height: 8),
  //         //       Row(
  //         //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //         children: [
  //         //           CustomText(
  //         //             text: "Total",
  //         //             style: CustomTextStyle.normalText.copyWith(
  //         //               fontSize: getSize(16),
  //         //             ),
  //         //           ),
  //         //           CustomText(
  //         //             text: "\$${bloc.cartTotal.toStringAsFixed(2)}",
  //         //             style: CustomTextStyle.normalText.copyWith(
  //         //               fontSize: getSize(16),
  //         //               fontWeight: FontWeight.bold,
  //         //               color: AppColors.primaryColor,
  //         //             ),
  //         //           ),
  //         //         ],
  //         //       ),
  //         //       getSizeBox(height: 16),
  //         //       SizedBox(
  //         //         width: double.infinity,
  //         //         child: ElevatedButton(
  //         //           style: ElevatedButton.styleFrom(
  //         //             backgroundColor: AppColors.primaryColor,
  //         //             shape: RoundedRectangleBorder(
  //         //               borderRadius: BorderRadius.circular(getSize(8)),
  //         //             ),
  //         //             padding: getPadding(top: 12, bottom: 12),
  //         //           ),
  //         //           onPressed: () {
  //         //             // Handle checkout
  //         //             // bloc.checkout();
  //         //           },
  //         //           child: CustomText(
  //         //             text: "Proceed to Checkout",
  //         //             style: CustomTextStyle.normalText.copyWith(
  //         //               color: AppColors.white,
  //         //             ),
  //         //           ),
  //         //         ),
  //         //       ),
  //         //     ],
  //         //   ),
  //         // ),

  //         ///section dropdown

  //         ///Place Order Button
  //         SizedBox(
  //           width: double.infinity,
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: AppColors.primaryColor,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(getSize(8)),
  //               ),
  //               padding: getPadding(top: 12, bottom: 12),
  //             ),
  //             onPressed: () {
  //               ///Check cart is not empty
  //               if (bloc.cartItems.isEmpty) {
  //                 HapticFeedback.vibrate();
  //                 showToast("Please add food items to cart");
  //                 return;
  //               }

  //               ///Place order
  //               bloc.orderFood(id);
  //             },
  //             child: CustomText(
  //               text: "Order",
  //               style: CustomTextStyle.normalText.copyWith(
  //                 color: AppColors.white,
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ],
  //   );
  // }

// final now = DateTime.now();
  Widget _buildQuantityControls(BuildContext context, FoodItem item) {
    final cubit = context.read<HomeCubit>();
    final cartItem = cubit.getCartItem(item.id);

    return Row(
      spacing: getSize(5),
      children: [
        Container(
          padding: getPadding(all: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getSize(12)),
            color: Color(0xFFB8B3AD),
          ),
          child: Row(
            spacing: getSize(10),
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Decrease button
              InkWell(
                onTap: () {
                  if (cartItem.quantity > 1) {
                    cubit.updateCartItemQuantity(
                        cartItem, cartItem.quantity - 1);
                  } else {
                    cubit.removeFromCart(cartItem);
                  }
                },
                child: Icon(
                  Icons.remove,
                  size: getSize(16),
                  color: AppColors.white,
                ),
              ),

              // Quantity display
              CustomText(
                text: cartItem.quantity.toString(),
                style: CustomTextStyle.headingText.copyWith(
                  color: AppColors.white,
                  fontSize: getSize(12),
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Increase button
              InkWell(
                onTap: () {
                  cubit.updateCartItemQuantity(cartItem, cartItem.quantity + 1);
                },
                child: Icon(
                  Icons.add,
                  size: getSize(16),
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),

        ///Show Special Instructions[Show if Food is in Cart]
        if (cubit.isItemInCart(item.id))
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Icon(Icons.more_vert,
                    color: AppColors.primaryColor, size: getSize(20)),
                onTap: () => _showSpecialInstructionsDialog(context, item),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context, FoodItem item) {
    return InkWell(
      onTap: () {
        context.read<HomeCubit>().addToCart(item);
      },
      child: Container(
        width: width / 2.5,
        padding: getMargin(top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF737070),
              Color(0xFF979292),
            ],
          ),
        ),
        child: Center(
          child: CustomText(
            text: "Add to Cart",
            style: CustomTextStyle.headingText.copyWith(
              color: AppColors.whiteText,
              overflow: TextOverflow.ellipsis,
              fontSize: getSize(11),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showSpecialInstructionsDialog(BuildContext context, FoodItem food) {
    final TextEditingController instructionsController =
        TextEditingController();
    final cubit = context.read<HomeCubit>();
    final currentCartItem = cubit.getCartItem(food.id);
    instructionsController.text = currentCartItem.specialInstruction;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getSize(16)),
        ),
        // insetPadding: getPadding(all: 20),
        child: Container(
          padding: getPadding(all: 20),
          decoration: BoxDecoration(
            color: AppColors.whiteText,
            borderRadius: BorderRadius.circular(getSize(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Special Instructions",
                    style: CustomTextStyle.headingText.copyWith(
                      fontSize: getSize(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: getSize(20)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // Food Info
              Container(
                margin: getMargin(top: 8, bottom: 16),
                padding: getPadding(all: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(getSize(8)),
                ),
                child: Row(
                  children: [
                    CustomImageView(
                      url: food.imageUrl,
                      fit: BoxFit.cover,
                      height: getSize(50),
                      width: getSize(50),
                      radius: BorderRadius.circular(getSize(8)),
                    ),
                    getSizeBox(width: 12),
                    Expanded(
                      child: CustomText(
                        text: food.name ?? "N/A",
                        style: CustomTextStyle.bodyText.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Input Field
              TextField(
                controller: instructionsController,
                decoration: InputDecoration(
                  hintText: "E.g. No onions, extra spicy, less salt...",
                  hintStyle: CustomTextStyle.bodyText.copyWith(
                    color: AppColors.textGrey4,
                  ),
                  filled: true,
                  fillColor: AppColors.bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(getSize(8)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: getPadding(all: 16),
                ),
                maxLines: 3,
                style: CustomTextStyle.bodyText,
              ),

              // Action Buttons
              Container(
                margin: getMargin(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: getPadding(
                            left: 16, right: 16, top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getSize(8)),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: CustomText(
                        text: "Cancel",
                        style: CustomTextStyle.bodyText.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    getSizeBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: getPadding(
                            left: 20, right: 20, top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getSize(8)),
                        ),
                      ),
                      onPressed: () {
                        if (instructionsController.text.isNotEmpty) {
                          // Add the special instructions to the cart
                          cubit.addSpecialInstruction(
                              instructionsController.text, currentCartItem);
                        }
                        Navigator.pop(context);
                      },
                      child: CustomText(
                        text: "Save Instructions",
                        style: CustomTextStyle.bodyText.copyWith(
                          color: AppColors.whiteText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
