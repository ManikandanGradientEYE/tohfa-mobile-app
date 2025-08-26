import 'package:demo/features/home/model/food_menu_model.dart';
import 'package:demo/features/home/model/meeting_model.dart';
import 'package:intl/intl.dart';

import '../../../export.dart';
import '../model/active_banner_model.dart';
import '../model/active_events_model.dart';
import '../model/section_model.dart';
import '../model/visit_status_model.dart';

class HomeCubit extends Cubit<HomeState> with ApiClientMixin {
  HomeCubit() : super(HomeInitial());
  ActiveBannersModel? activeBannersModel;
  ActiveEventsModel? activeEventsModel;
  ActiveFoodsModel? activeFoodsModel;
  bool showCart = false;
  String? orderToken;
  String? selectedCategory;
  List<CartItem> cartItems = [];
  List<VisitStatusModel> visitStatusModel = [];
  List<SectionModel> sectionModel = [];
  VisitStatusModel? selectedVisitStatusModel;
  SectionModel? selectedSectionModel;
  MeetingsList? meetingModel;
  List<MeetingsList>? meetingsList;
  String? customerRequestLink;

  // Toggle cart view
  void toggleCartView(bool show) {
    showCart = show;
    successState();
  }

  successState() {
    emit(HomeSuccessState());
  }

  // Add to cart
  void addToCart(FoodItem foodItem) {
    /// Check if the item is not already in the cart then add it
    if (!isItemInCart(foodItem.id)) {
      cartItems.add(
        CartItem(
          catName: foodItem.menucategoryname ?? "",
          id: foodItem.id.toString(),
          name: foodItem.name ?? "",
          imageUrl: foodItem.imageUrl ?? "",
          price: double.parse(foodItem.price ?? "0"),
        ),
      );
    } else {
      final existingItem = cartItems.firstWhere(
        (item) => item.id == foodItem.id.toString(),
      );

      existingItem.quantity++;
    }
    emit(HomeSuccessState());
  }

  // Remove from cart
  void removeFromCart(CartItem item) {
    cartItems.remove(item);
    if (cartItems.isEmpty) {
      showCart = false;
    }
    emit(HomeSuccessState());
  }

  bool isItemInCart(int? itemId) {
    return cartItems.any((item) => item.id == itemId.toString());
  }

  CartItem getCartItem(int? itemId) {
    return cartItems.firstWhere((item) => item.id == itemId.toString());
  }

  // Update quantity
  void updateCartItemQuantity(CartItem item, int newQuantity) {
    if (newQuantity > 0) {
      item.quantity = newQuantity;
    } else {
      removeFromCart(item);
    }
    emit(HomeSuccessState());
  }

  // Calculate subtotal
  double get cartSubtotal => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  // Calculate tax (example: 10%)
  double get cartTax => cartSubtotal * 0.1;

  // Calculate total
  double get cartTotal => cartSubtotal + cartTax;

  getActiveBanners() async {
    emit(HomeInitial());
    try {
      final response = await apiClient.get(
        ApiConstants.activeBanners,
        (p0) => p0,
      );
      // await apiClient.get(
      //   ApiConstants.customerSite+"?customerId=65",
      //   (p0) => p0,
      // );
      if (response.success) {
        activeBannersModel = activeBannersModelFromJson(jsonEncode(response.data));
        successState();
        // await getEventBanners();
      } else {
        emit(HomeErrorState(error: response.errorMessage ?? AppStrings.somethingWentWrong));
      }
    } catch (e) {
      emit(HomeErrorState(error: AppStrings.somethingWentWrong));
      logV("Error===>$e");
    }
  }

  getEventBanners() async {
    emit(HomeLoadingState());
    try {
      final response = await apiClient.get(
        ApiConstants.activeEvents,
        (p0) => p0,
      );
      if (response.success) {
        activeEventsModel = activeEventsModelFromJson(jsonEncode(response.data));
        successState();
        // await activeFoodMenu();
      } else {
        emit(HomeErrorState(error: response.errorMessage ?? AppStrings.somethingWentWrong));
      }
    } catch (e) {
      emit(HomeErrorState(error: AppStrings.somethingWentWrong));
      logV("Error===>$e");
    }
  }

  activeFoodMenu(String id) async {
    emit(HomeLoadingState());
    try {
      final response = await apiClient.get(
        "${ApiConstants.activeFoodMenu}?siteId=$id",
        (p0) => p0,
      );
      if (response.success) {
        activeFoodsModel = activeFoodsModelFromJson(jsonEncode(response.data));
        emit(HomeSuccessState());
      } else {
        emit(HomeErrorState(error: response.errorMessage ?? AppStrings.somethingWentWrong));
      }
    } catch (e) {
      emit(HomeErrorState(error: AppStrings.somethingWentWrong));
      logV("Error===>$e");
    }
  }

  getVisitStatus() async {
    emit(HomeLoadingState());
    try {
      final response = await apiClient.get(
        "${ApiConstants.visitStatus}?customerSiteId=${Singleton.instance.userData?.id}",
        // "${ApiConstants.visitStatus}?customerSiteId=68",
        (p0) => p0,
      );
      if (response.success) {
        visitStatusModel = visitStatusModelFromJson(jsonEncode(response.data))
            .where(
              (element) => element.isFoodFacilityAvailable ?? true,
            )
            .toList();
        if (visitStatusModel.length != 1) {
          emit(HomeSuccessState());
        } else {
          selectedVisitStatusModel = visitStatusModel.first;
          await getAllSections(selectedVisitStatusModel!.siteId.toString());
          await activeFoodMenu(selectedVisitStatusModel!.siteId.toString());
        }
      } else {
        emit(HomeSuccessState());
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
      }
    } catch (e) {
      emit(HomeSuccessState());
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
    }
  }

  getAllSections(String siteId) async {
    emit(HomeLoadingState());
    try {
      final response = await apiClient.get(
        // "${ApiConstants.visitStatus}?customerSiteId=${Singleton.instance.userData?.id}",
        "${ApiConstants.getSection}?siteId=$siteId",
        (p0) => p0,
      );
      if (response.success) {
        sectionModel = sectionModelFromJson(jsonEncode(response.data));
        emit(HomeSuccessState());
      } else {
        emit(HomeSuccessState());
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
      }
    } catch (e) {
      emit(HomeSuccessState());
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
    }
  }

  // MeetingList

  Future<void> getAllMeeting(String siteId) async {
    emit(HomeLoadingState());

    try {
      final response = await apiClient.get(
        "${ApiConstants.meetings}?customerSiteId=$siteId",
        (data) => data,
      );

      if (response.success) {
        final List<MeetingsList> meetings = meetingsListFromJson(jsonEncode(response.data));

        meetingsList = meetings;
        emit(HomeSuccessState());
      } else {
        emit(HomeErrorState(error: response.errorMessage ?? AppStrings.somethingWentWrong));
      }
    } catch (e) {
      emit(HomeErrorState(error: AppStrings.somethingWentWrong));
      logV("Error===>$e");
    }
  }

// customerRequest

  Future<void> getcustomerRequest(String siteId) async {
    emit(HomeLoadingState());
    try {
      final response = await apiClient.get(
        ApiConstants.customerRequest,
        (data) => data,
      );

      if (response.success) {
        final link = response.data as String?;
        if (link != null && link.isNotEmpty) {
          customerRequestLink = link;
          emit(CustomerRequestSuccessState(link));
          emit(HomeSuccessState());
          log(customerRequestLink.toString(), name: "WEB VIEW URL");
        } else {
          emit(HomeErrorState(
            error: response.errorMessage ?? AppStrings.somethingWentWrong,
          ));
        }
      } else {
        emit(HomeErrorState(
          error: response.errorMessage ?? AppStrings.somethingWentWrong,
        ));
      }
    } catch (e) {
      emit(HomeErrorState(error: AppStrings.somethingWentWrong));
      logV("Error===>$e");
    }
  }

  ///Add special instruction
  void addSpecialInstruction(String instruction, CartItem item) {
    CartItem existingItem = cartItems.firstWhere(
      (cartItem) => cartItem.id == item.id,
      orElse: () => item,
    );
    existingItem.specialInstruction = instruction;
    emit(HomeSuccessState());
  }

  ///Order food
  Future<void> orderFood(String siteId) async {
    emit(HomeLoadingState());
    try {
      ///{
      //   "CustomerSiteId": "68",
      //   "FoodOrderNo": "545",
      //   "FoodOrderDate": "2025-04-28",
      //   "CustomerSiteName": "Main Office",
      //   "TotalQty": "5",
      //   "TotalValue": "150.00",
      //   "DeliverySection": "Cafeteria",
      //   "FOStatus": "New",
      //   "siteId": "1",
      //   "details": [
      //     {
      //       "CategoryName": "Beverages",
      //       "FoodMenuName": "Coffee",
      //       "ItemQty": "2",
      //       "ItemRate": "20",
      //       "ItemDelvStatus": "Not Delivered",
      //       "ItemInstructions": "Extra sugar"
      //     },
      //     {
      //       "CategoryName": "Main Course",
      //       "FoodMenuName": "Pasta",
      //       "ItemQty": "3",
      //       "ItemRate": "30",
      //       "ItemDelvStatus": "Not Delivered",
      //       "ItemInstructions": "No cheese"
      //     }
      //   ]
      // }
      var body = {
        "CustomerSiteId": Singleton.instance.userData!.id.toString(),
        "FoodOrderNo": "0",
        "FoodOrderDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "CustomerSiteName": Singleton.instance.userData!.customerSiteName ?? "",
        "TotalQty": cartItems.length.toString(),
        "TotalValue": cartSubtotal.toString(),
        "DeliverySection": selectedSectionModel?.text ?? "Admin",
        "FOStatus": "New",
        "siteId": siteId,
        "details": cartItems.map((item) {
          return {
            "CategoryName": item.catName,
            "FoodMenuName": item.name,
            "ItemQty": item.quantity.toString(),
            "ItemRate": item.price.toString(),
            "ItemDelvStatus": "Not Delivered",
            "ItemInstructions": item.specialInstruction,
          };
        }).toList(),
      };
      final response = await apiClient.post(
        ApiConstants.foodOrder,
        (p0) => p0,
        body: jsonEncode(body),
        headers: Singleton.instance.getAuthHeaders(withType: true),
      );
      if (response.success) {
        cartItems.clear();
        orderToken = response.data["data"];
        showToast("Order placed successfully");
        cartItems.clear();
        showCart = false;
        selectedSectionModel = null;
        emit(HomeSuccessState());
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
        emit(HomeSuccessState());
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      emit(HomeErrorState(error: AppStrings.somethingWentWrong));
      logV("Error===>$e");
      emit(HomeSuccessState());
    }
  }
}

class CartItem {
  final String id;
  final String name;
  final String catName;
  final String imageUrl;
  final double price;
  String specialInstruction;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.catName,
    required this.imageUrl,
    this.specialInstruction = "",
    required this.price,
    this.quantity = 1,
  });
}
