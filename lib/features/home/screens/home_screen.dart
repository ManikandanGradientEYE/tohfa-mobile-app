import 'package:demo/features/home/model/food_menu_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/custom_drop_down.dart';
import '../../../export.dart';
import '../model/active_banner_model.dart';
import '../model/active_events_model.dart';
import '../model/section_model.dart';
import '../model/visit_status_model.dart';
import 'book_call_screen.dart';
import 'meal_order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit()..getActiveBanners(),
      child: const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  ScrollController? scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppBar(),
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) async {
            final bloc = context.read<HomeCubit>();
            if (bloc.orderToken != null) {
              await _showNormalDialog(context, bloc.orderToken!);
              bloc.orderToken = null;
            }
          },
          builder: (context, state) {
            if (state is HomeErrorState) {
              return _buildErrorState(context, state);
            } else if (state is HomeSuccessState || state is HomeLoadingState) {
              return _buildSuccessState(context, state);
            } else {
              return const Center(child: CustomLoading());
            }
          },
        ),
      ),
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
                    color: Color(0xFF3F3F3F), fontWeight: FontWeight.w500, fontSize: getSize(15)),
              ),
              getSizeBox(height: 10),
              CustomText(
                textAlign: TextAlign.center,
                text: "with Token No: “$token”",
                style: CustomTextStyle.normalText.copyWith(
                    color: Color(0xFF646464), fontWeight: FontWeight.w500, fontSize: getSize(14)),
              ),
              getSizeBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgColor,
      leadingWidth: getSize(120),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: getPadding(left: 10),
            child: CustomImageView(
              imagePath: ImageConstants.appLogo2,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: CustomImageView(
            imagePath: ImageConstants.phone,
            color: AppColors.primaryColor,
            height: 20,
            width: 20,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: CustomImageView(
            imagePath: ImageConstants.notification,
            color: AppColors.primaryColor,
            height: 20,
            width: 20,
          ),
          onPressed: () {},
        ),
        getSizeBox(width: 8),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, HomeErrorState state) {
    return RefreshIndicator(
      onRefresh: () {
        context.read<HomeCubit>().getActiveBanners();
        return Future.delayed(Duration.zero);
      },
      backgroundColor: AppColors.white,
      color: AppColors.primaryColor,
      child: NoDataFoundView(message: state.error),
    );
  }

  Widget _buildSuccessState(
    BuildContext context,
    HomeState state,
  ) {
    final bloc = context.read<HomeCubit>();
    final catalog = (bloc.activeBannersModel?.data ?? [])
        .where((element) => element.category == "Catalog")
        .toList();
    final offers = (bloc.activeBannersModel?.data ?? [])
        .where((element) => element.category == "Offer")
        .toList();
    final foodMenu = (bloc.activeBannersModel?.data ?? [])
        .where((element) => element.category == "Food Menu")
        .toList();
    final food = (bloc.activeFoodsModel?.data ?? []).toList();
    final event = bloc.activeEventsModel?.data;
    return Stack(
      children: [
        SingleChildScrollView(
          padding: getPadding(left: 16, right: 16, top: 0, bottom: 5),
          controller: _selectedTabIndex == 1 ? scrollController : null,
          child: Column(
            spacing: getSize(10),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingText(),
              _buildTabBarButtons(context),
              _selectedTabIndex == 0
                  ? _catalogBuilder(catalog)
                  : _selectedTabIndex == 1
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: ZohoBookingEmbed(),
                        )
                      : _selectedTabIndex == 2
                          ? _offersBuilder(offers)
                          : _selectedTabIndex == 3
                              ? _foodMenuBuilder(foodMenu, food, context)
                              : _selectedTabIndex == 4
                                  ? _upcomingEventBuilder(event)
                                  : SizedBox()
            ],
          ),
        ),
        Visibility(
          visible: state is HomeLoadingState,
          child: Container(
            color: AppColors.black.withValues(alpha: .07),
            child: CustomLoading(),
          ),
        )
      ],
    );
  }

  Widget _buildGreetingText() {
    final data = Singleton.instance.userData;
    return CustomText(
      text:
          "Hello ${data?.customerName ?? data?.customerSiteShortName ?? data?.customerSiteName ?? "N/A"}",
      style: CustomTextStyle.headingText.copyWith(
        fontSize: 18,
        color: AppColors.textGrey2,
      ),
    );
  }


  Widget _buildTabBarButtons(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final List<Map<String, String>> tabItems = [
      {"title": "Browse", "subtitle": "Catalog"},
      {"title": "Request a", "subtitle": "Video Call"},
      {"title": "Ongoing", "subtitle": "Offers"},
      {"title": "Browse", "subtitle": "Food Menu"},
      {"title": "Upcoming", "subtitle": "Events"},
    ];

    return Padding(
      padding: getPadding(top: 5),
      child: Column(
        spacing: 5,
        children: [
          Divider(
            color: AppColors.boarder2,
            height: getSize(.7),
          ),
          SizedBox(
            height: getSize(42),
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                  if (index == 1) {
                    scrollController = ScrollController();
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   scrollController!.jumpTo(150);
                    // });
                  }
                  if (_selectedTabIndex == 3 && cubit.visitStatusModel.isEmpty) {
                    // await cubit.activeFoodMenu();
                    await cubit.getVisitStatus();
                  } else if (_selectedTabIndex == 4 && cubit.activeEventsModel == null) {
                    await cubit.getEventBanners();
                  }
                },
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: tabItems[index]["title"]!,
                        style: CustomTextStyle.normalText.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: getSize(11),
                          color: AppColors.primaryText2,
                        ),
                      ),
                      CustomText(
                        text: tabItems[index]["subtitle"]!,
                        style: CustomTextStyle.normalText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: getSize(12),
                          color: AppColors.primaryText2,
                        ),
                      ),
                      Container(
                        height: 5,
                        margin: getPadding(top: 2),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == index
                              ? AppColors.secondaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(getSize(2)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              separatorBuilder: (context, index) => VerticalDivider(
                width: getSize(20),
                color: Colors.grey[300],
              ),
              itemCount: tabItems.length,
            ),
          ),
          Divider(
            color: AppColors.boarder3,
            height: getSize(.7),
          ),
          Divider(
            color: AppColors.boarder3,
            height: getSize(.7),
          ),
        ],
      ),
    );
  }

  Widget _catalogBuilder(List<BannerModel> catalog) {
    return catalog.isEmpty
        ? Center(
            child: CustomText(
            textAlign: TextAlign.center,
            text: AppStrings.noRecordFound,
            style: CustomTextStyle.normalText.copyWith(
                color: AppColors.primaryColor, fontWeight: FontWeight.w500, fontSize: getSize(15)),
          ))
        : ListView.separated(
            primary: false,
            separatorBuilder: (context, index) => getSizeBox(height: 10),
            itemBuilder: (context, index) => InkWell(
              onTap: () async {
                if (catalog[index].shopifyUrl != null) {
                  await launchUrl(Uri.parse(catalog[index].shopifyUrl!));
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(getSize(16)),
                child: Container(
                  height: getSize(135),
                  decoration: BoxDecoration(
                      color: AppColors.whiteText, borderRadius: BorderRadius.circular(getSize(16))),
                  child: CustomImageView(
                    height: getSize(135),
                    fit: BoxFit.cover,
                    url: catalog[index].bannerUrl,
                  ),
                ),
              ),
            ),
            shrinkWrap: true,
            itemCount: catalog.length,
          );
  }

  Widget _offersBuilder(List<BannerModel> catalog) {
    return catalog.isEmpty
        ? Center(
            child: CustomText(
            textAlign: TextAlign.center,
            text: AppStrings.noRecordFound,
            style: CustomTextStyle.normalText.copyWith(
                color: AppColors.primaryColor, fontWeight: FontWeight.w500, fontSize: getSize(15)),
          ))
        : ListView.separated(
            primary: false,
            separatorBuilder: (context, index) => getSizeBox(height: 10),
            itemBuilder: (context, index) => InkWell(
              onTap: () async {
                if (catalog[index].shopifyUrl != null) {
                  await launchUrl(Uri.parse(catalog[index].shopifyUrl!));
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(getSize(12)),
                      topRight: Radius.circular(getSize(4)),
                      bottomLeft: Radius.circular(getSize(5)),
                      bottomRight: Radius.circular(getSize(40)),
                    ),
                    child: Container(
                      padding: getPadding(right: 2, bottom: 5),
                      width: double.infinity,
                      height: getSize(140),
                      decoration: BoxDecoration(
                          color: AppColors.whiteText,
                          borderRadius: BorderRadius.circular(getSize(16))),
                      child: CustomImageView(
                        height: getSize(140),
                        fit: BoxFit.cover,
                        url: catalog[index].bannerUrl,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: getSize(35),
                      width: getSize(35),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: .95),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.arrow_forward_outlined,
                          color: AppColors.whiteText,
                          size: getSize(20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            shrinkWrap: true,
            itemCount: catalog.length,
          );
  }

  Widget _foodMenuBuilder(
    List<BannerModel> catalog,
    List<FoodItem> food,
    BuildContext context,
  ) {
    final bloc = context.read<HomeCubit>();
    List<VisitStatusModel> newVisitStatusModel = bloc.visitStatusModel;

    // Filter out "Meals" category and get all unique categories
    List<FoodItem> newFoodList =
        food.where((element) => element.menucategoryname != "Meals").toList();
    List<String> categories =
        newFoodList.map((e) => e.menucategoryname ?? "Other").toSet().toList();

    // State for selected category
    bloc.selectedCategory ??= categories.isNotEmpty ? categories.first : "";

    return StatefulBuilder(
      builder: (context, setState) {
        // Filter food items by selected category
        List<FoodItem> filteredFoodList = (bloc.selectedCategory ?? '').isEmpty
            ? newFoodList
            : newFoodList.where((item) => item.menucategoryname == bloc.selectedCategory).toList();

        return Column(
          spacing: getSize(10),
          children: [
            // Category selector
            ///Show custom Dropdown of visitStatusModel
            customDropDown2(
              newVisitStatusModel,
              (p0) => p0.siteName ?? "N/A",
              onChanged: (value) {
                if (bloc.selectedVisitStatusModel?.siteId != value?.siteId) {
                  bloc.cartItems.clear();
                  bloc.showCart = false;
                }
                bloc.selectedVisitStatusModel = value;
                if (value != null) {
                  bloc.sectionModel.clear();
                  bloc.activeFoodMenu(value.siteId.toString());
                  bloc.getAllSections(value.siteId.toString());
                }
              },
              customLabel: SizedBox(),
              hintText: "Select Site",
              enabled: newVisitStatusModel.isNotEmpty,
              valueText: bloc.selectedVisitStatusModel?.siteName,
              disableMessage: bloc.visitStatusModel.isEmpty
                  ? "Need to visit to place a food order"
                  : newVisitStatusModel.isEmpty
                      ? "This site is not providing food service"
                      : null,
              labelText: "Visit Status",
            ),

            if (bloc.selectedVisitStatusModel != null)
              bloc.showCart
                  ? _foodCartView(context)
                  : Column(
                      children: [
                        catalog.isEmpty
                            ? SizedBox()
                            : SizedBox(
                                height: getSize(190),
                                child: ListView.separated(
                                  primary: false,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) => getSizeBox(height: 10),
                                  itemBuilder: (context, index) => ClipRRect(
                                    borderRadius: BorderRadius.circular(getSize(16)),
                                    child: Container(
                                      height: getSize(190),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteText,
                                          borderRadius: BorderRadius.circular(getSize(16))),
                                      child: Stack(
                                        children: [
                                          CustomImageView(
                                            height: getSize(190),
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.cover,
                                            url: catalog[index].bannerUrl ?? "",
                                          ),
                                          Positioned(
                                              top: 0,
                                              bottom: 0,
                                              left: 10,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                spacing: getSize(10),
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: "Your lunch is on us!",
                                                    style: CustomTextStyle.headingText.copyWith(
                                                        color: AppColors.whiteText,
                                                        fontSize: getSize(18),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (bloc.selectedVisitStatusModel == null)
                                                        return;
                                                      NavigatorService.push(
                                                          context,
                                                          MealOrderScreen.builder(
                                                              context,
                                                              bloc.selectedVisitStatusModel!.siteId
                                                                  .toString()));
                                                    },
                                                    child: Container(
                                                      padding: getMargin(
                                                          left: 20, right: 20, top: 5, bottom: 5),
                                                      decoration: BoxDecoration(
                                                          color: AppColors.black
                                                              .withValues(alpha: .26),
                                                          borderRadius:
                                                              BorderRadius.circular(getSize(7))),
                                                      child: CustomText(
                                                        text: "Book a Seat",
                                                        style: CustomTextStyle.headingText.copyWith(
                                                            color: AppColors.whiteText,
                                                            fontSize: getSize(11),
                                                            fontWeight: FontWeight.w400),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  shrinkWrap: true,
                                  itemCount: catalog.length,
                                ),
                              ),
                        getSizeBox(height: 10),
                        categories.isEmpty
                            ? SizedBox()
                            : SizedBox(
                                height: getSize(165),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  separatorBuilder: (context, index) => getSizeBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final category = categories[index];
                                    final isSelected = category == bloc.selectedCategory;

                                    // Find first item with image in this category
                                    final categoryItem = newFoodList.firstWhere(
                                      (item) =>
                                          item.menucategoryname == category &&
                                          item.imageUrl != null &&
                                          item.imageUrl != "undefined",
                                      orElse: () => FoodItem(),
                                    );
                                    logV("categoryItem===>${jsonEncode(category)}");

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          bloc.selectedCategory = category;
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(getSize(8)),
                                            child: Container(
                                              height: getSize(150),
                                              color:
                                                  isSelected ? AppColors.white : Colors.grey[300],
                                              width: getSize(135),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: getSize(80),
                                                    width: double.infinity,
                                                    child: CustomImageView(
                                                      url: categoryItem.imageUrl ?? "",
                                                      height: getSize(80),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        CustomText(
                                                          text: category,
                                                          style: CustomTextStyle.headingText
                                                              .copyWith(
                                                                  color: AppColors.primaryColor,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  fontSize: getSize(16),
                                                                  fontWeight: FontWeight.w500),
                                                        ),
                                                        getSizeBox(height: 10)
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            left: 0,
                                            child: Container(
                                              height: getSize(35),
                                              width: getSize(35),
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppColors.primaryColor.withValues(alpha: .35),
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: Icon(
                                                  Icons.arrow_forward_outlined,
                                                  color: AppColors.whiteText,
                                                  size: getSize(20),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "Good Afternoon,",
                                    style: CustomTextStyle.headingText.copyWith(
                                        color: AppColors.primaryColor,
                                        fontSize: getSize(16),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  CustomText(
                                    text: "Hungry, Checkout our Snacks Menu ",
                                    style: CustomTextStyle.headingText.copyWith(
                                        color: AppColors.textGrey3,
                                        fontSize: getSize(14),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),

                            ///Show Cart Button
                            Visibility(
                              visible: bloc.cartItems.isNotEmpty,
                              child: InkWell(
                                onTap: () {
                                  bloc.toggleCartView(true);
                                },
                                child: Container(
                                  padding: getPadding(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(getSize(8)),
                                  ),
                                  child: CustomText(
                                    text: "Show Cart",
                                    style: CustomTextStyle.headingText.copyWith(
                                        color: AppColors.whiteText,
                                        fontSize: getSize(14),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        getSizeBox(height: 10),
                        // Full list of filtered items
                        ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => getSizeBox(height: 10),
                          itemBuilder: (context, index) =>
                              _singleFoodItemBuilder(filteredFoodList[index]),
                          itemCount: filteredFoodList.length,
                        ),
                        getSizeBox(height: 20),
                      ],
                    ),
          ],
        );
      },
    );
  }

  ///Single Food Item
  Widget _singleFoodItemBuilder(FoodItem food) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(getSize(8)),
      child: Container(
        height: getSize(100),
        color: AppColors.whiteText,
        child: Row(
          spacing: getSize(10),
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                color: AppColors.white,
                child: CustomImageView(
                  url: food.imageUrl ?? "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                        // CustomText(
                        //   text: food.menucategoryname ?? "N/A",
                        //   style: CustomTextStyle.headingText.copyWith(
                        //     color: AppColors.primaryColor,
                        //     overflow: TextOverflow.ellipsis,
                        //     fontSize: getSize(16),
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
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
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            // Add More Button Column
          ],
        ),
      ),
    );
  }

  void _showSpecialInstructionsDialog(BuildContext context, FoodItem food) {
    final TextEditingController instructionsController = TextEditingController();
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
                        padding: getPadding(left: 16, right: 16, top: 10, bottom: 10),
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
                        padding: getPadding(left: 20, right: 20, top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getSize(8)),
                        ),
                      ),
                      onPressed: () {
                        if (instructionsController.text.isNotEmpty) {
                          // Add the special instructions to the cart
                          cubit.addSpecialInstruction(instructionsController.text, currentCartItem);
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
                    cubit.updateCartItemQuantity(cartItem, cartItem.quantity - 1);
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
                child: Icon(Icons.more_vert, color: AppColors.primaryColor, size: getSize(20)),
                onTap: () => _showSpecialInstructionsDialog(context, item),
              ),
            ],
          ),
      ],
    );
  }

  Widget _foodCartView(BuildContext context) {
    final bloc = context.read<HomeCubit>();
    List<VisitStatusModel> newVisitStatusModel =
        bloc.visitStatusModel.where((element) => element.isFoodFacilityAvailable ?? false).toList();

    List<SectionModel> newSectionModel =
        bloc.sectionModel.where((element) => !(element.disabled ?? false)).toList();
    return Column(
      spacing: getSize(10),
      children: [
        // Cart header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Your Cart",
              style: CustomTextStyle.headingText.copyWith(
                fontSize: getSize(18),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: AppColors.primaryColor),
              onPressed: () {
                bloc.toggleCartView(false);
              },
            ),
          ],
        ),

        Container(
          // m: getPadding(all: 16),

          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.primaryColor.withValues(alpha: .84)),
          ),
          child: ListView.separated(
            primary: false,
            shrinkWrap: true,
            padding: getPadding(all: 5),
            itemCount: bloc.cartItems.length,
            separatorBuilder: (_, __) => getSizeBox(height: 5),
            itemBuilder: (context, index) {
              final item = bloc.cartItems[index];

              ///get food item from food list
              final food = (bloc.activeFoodsModel?.data ?? []).firstWhere(
                (element) => element.id.toString() == item.id,
                orElse: () => FoodItem(),
              );
              return _singleFoodItemBuilder(food);
            },
          ),
        ),

        if (bloc.cartItems.isNotEmpty) ...[
          Divider(height: 1),
          // Padding(
          //   padding: getPadding(all: 16),
          //   child: Column(
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           CustomText(
          //             text: "Subtotal",
          //             style: CustomTextStyle.normalText,
          //           ),
          //           CustomText(
          //             text: "\$${bloc.cartSubtotal.toStringAsFixed(2)}",
          //             style: CustomTextStyle.normalText.copyWith(
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //       getSizeBox(height: 8),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           CustomText(
          //             text: "Tax",
          //             style: CustomTextStyle.normalText,
          //           ),
          //           CustomText(
          //             text: "\$${bloc.cartTax.toStringAsFixed(2)}",
          //             style: CustomTextStyle.normalText.copyWith(
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //       getSizeBox(height: 8),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           CustomText(
          //             text: "Total",
          //             style: CustomTextStyle.normalText.copyWith(
          //               fontSize: getSize(16),
          //             ),
          //           ),
          //           CustomText(
          //             text: "\$${bloc.cartTotal.toStringAsFixed(2)}",
          //             style: CustomTextStyle.normalText.copyWith(
          //               fontSize: getSize(16),
          //               fontWeight: FontWeight.bold,
          //               color: AppColors.primaryColor,
          //             ),
          //           ),
          //         ],
          //       ),
          //       getSizeBox(height: 16),
          //       SizedBox(
          //         width: double.infinity,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: AppColors.primaryColor,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(getSize(8)),
          //             ),
          //             padding: getPadding(top: 12, bottom: 12),
          //           ),
          //           onPressed: () {
          //             // Handle checkout
          //             // bloc.checkout();
          //           },
          //           child: CustomText(
          //             text: "Proceed to Checkout",
          //             style: CustomTextStyle.normalText.copyWith(
          //               color: AppColors.white,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          ///section dropdown
          // if (bloc.selectedVisitStatusModel != null)
          customDropDown2(
            newSectionModel,
            (p0) => p0.text ?? "N/A",
            onChanged: (value) {
              bloc.selectedSectionModel = value;
              bloc.successState();
            },
            customLabel: SizedBox(),
            hintText: "Select Section",
            enabled: newVisitStatusModel.isNotEmpty,
            valueText: bloc.selectedSectionModel?.text,
            disableMessage:
                newSectionModel.isEmpty ? "This site is not providing section service" : null,
            labelText: "Section",
          ),

          ///Place Order Button
          SizedBox(
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

                ///Check visit status is selected
                if (bloc.selectedVisitStatusModel == null) {
                  HapticFeedback.vibrate();
                  showToast("Please select visit status");
                  return;
                }

                ///Check section is selected
                if (bloc.selectedSectionModel == null) {
                  HapticFeedback.vibrate();
                  showToast("Please select section");
                  return;
                }

                ///Place order
                bloc.orderFood(bloc.selectedVisitStatusModel!.siteId.toString() , true);
              },
              child: CustomText(
                text: "Order 12",
                style: CustomTextStyle.normalText.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          )
        ],
      ],
    );
  }

  Widget _upcomingEventBuilder(List<EventItem>? event) {
    return event == null
        ? SizedBox()
        : event.isEmpty
            ? Center(
                child: CustomText(
                textAlign: TextAlign.center,
                text: AppStrings.noRecordFound,
                style: CustomTextStyle.normalText.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: getSize(15)),
              ))
            : ListView.separated(
                primary: false,
                separatorBuilder: (context, index) => getSizeBox(height: 10),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(event[index].title ?? "No Title"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (event[index].imageUrl != null)
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                height: getSize(150),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomImageView(
                                  url: event[index].imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            Text(
                                "Date & Time: ${event[index].eventDateTime != null ? DateFormat('EEE, d MMM yyyy • hh:mm a').format(DateTime.parse(event[index].eventDateTime!)) : "N/A"}"),
                            SizedBox(height: 5),
                            Text("Venue: ${event[index].venue ?? 'N/A'}"),
                            SizedBox(height: 5),
                            Text("Description: ${event[index].description ?? 'N/A'}"),
                            SizedBox(height: 5),
                            if (event[index].remarks != null)
                              Text("Remarks: ${event[index].remarks}"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Close"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: getMargin(all: 5),
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.whiteText,
                      border: Border.all(color: Color(0xFFEED070), width: getSize(1)),
                    ),
                    child: Row(
                      spacing: getSize(10),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image container
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteText,
                            borderRadius: BorderRadius.circular(getSize(4)),
                          ),
                          height: getSize(72),
                          width: getSize(72),
                          child: CustomImageView(
                            url: event[index].imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Main content area
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top row with title and date
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          text: event[index].title ?? "N/A",
                                          style: CustomTextStyle.headingText.copyWith(
                                            color: AppColors.primaryColor,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: getSize(16),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        CustomText(
                                          text: event[index].eventDateTime == null
                                              ? "N/A"
                                              : DateFormat('EEE d MMM, hh:mm a').format(
                                                  DateTime.parse(event[index].eventDateTime!)),
                                          style: CustomTextStyle.headingText.copyWith(
                                            color: AppColors.textGrey4,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: getSize(12),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        // Location row
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: getSize(14),
                                              color: AppColors.textGrey4,
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                text: event[index].venue ?? "N/A",
                                                style: CustomTextStyle.headingText.copyWith(
                                                  color: AppColors.textGrey4,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: getSize(10),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 38,
                                    height: 50,
                                    padding: getPadding(all: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(getSize(8)),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        textAlign: TextAlign.center,
                                        text: event[index].eventDateTime == null
                                            ? "N/A"
                                            : DateFormat('d \n EEE').format(
                                                DateTime.parse(event[index].eventDateTime!)),
                                        style: CustomTextStyle.headingText.copyWith(
                                          color: AppColors.whiteText,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: getSize(13),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Date time text
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                shrinkWrap: true,
                itemCount: event.length,
              );
  }
}
